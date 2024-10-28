//{"a":10,"arr":7,"emit_logp":2,"logp":8,"num_states":6,"obs_idx":5,"p":9,"rand":4,"state_logp":1,"states":0,"temp_logp":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sum(global float* arr, int start, int length) {
  float result = 0;
  for (int i = start; i < start + length; i++) {
    result += arr[hook(7, i)];
  }
  return result;
}

float max_arr(global float* arr, int start, int length) {
  float result = arr[hook(7, start)];
  for (int i = start + 1; i < start + length; i++) {
    result = fmax(result, arr[hook(7, i)]);
  }
  return result;
}

void lognormalize(global float* logp, int start, int length) {
  float m = max_arr(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(8, i)] = powr(exp(1.0f), logp[hook(8, i)] - m);
  }
  float p_sum = sum(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(8, i)] = logp[hook(8, i)] / p_sum;
  }
}

unsigned int sample(unsigned int a_size, global unsigned int* a, global float* p, int start, float rand) {
  float total = 0.0f;
  for (unsigned int i = start; i < start + a_size; i++) {
    total = total + p[hook(9, i)];
    if (total > rand)
      return a[hook(10, i - start)];
  }
  return a[hook(10, a_size - 1)];
}

kernel void resample_state(global int* states, global float* state_logp, global float* emit_logp, global float* temp_logp, global float* rand, unsigned int obs_idx, unsigned int num_states) {
  for (unsigned int i = 0; i < num_states; i++) {
    temp_logp[hook(3, i)] = state_logp[hook(1, obs_idx * num_states + i)] + emit_logp[hook(2, obs_idx * num_states + i)];
  }

  lognormalize(temp_logp, 0, num_states);

  float total = 0.0f;
  for (unsigned int i = 0; i < num_states; i++) {
    total += temp_logp[hook(3, i)];
    if (total > rand[hook(4, obs_idx)]) {
      states[hook(0, obs_idx)] = i + 1;
      return;
    }
  }
  states[hook(0, obs_idx)] = num_states;
}