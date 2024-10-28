//{"N":4,"a":8,"arr":5,"logp":6,"obs_idx":3,"p":7,"state_logp":2,"states":0,"trans_p_matrix":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sum(global float* arr, int start, int length) {
  float result = 0;
  for (int i = start; i < start + length; i++) {
    result += arr[hook(5, i)];
  }
  return result;
}

float max_arr(global float* arr, int start, int length) {
  float result = arr[hook(5, start)];
  for (int i = start + 1; i < start + length; i++) {
    result = fmax(result, arr[hook(5, i)]);
  }
  return result;
}

void lognormalize(global float* logp, int start, int length) {
  float m = max_arr(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(6, i)] = powr(exp(1.0f), logp[hook(6, i)] - m);
  }
  float p_sum = sum(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(6, i)] = logp[hook(6, i)] / p_sum;
  }
}

unsigned int sample(unsigned int a_size, global unsigned int* a, global float* p, int start, float rand) {
  float total = 0.0f;
  for (unsigned int i = start; i < start + a_size; i++) {
    total = total + p[hook(7, i)];
    if (total > rand)
      return a[hook(8, i - start)];
  }
  return a[hook(8, a_size - 1)];
}

kernel void calc_state_logp(global int* states, global float* trans_p_matrix, global float* state_logp, unsigned int obs_idx, unsigned int N) {
  int state_idx = get_global_id(0);
  int num_states = get_global_size(0);

  float trans_prev_logp = (obs_idx != 0) * log(trans_p_matrix[hook(1, (states[ohook(0, obs_idx - 1 * (obs_idx != 0)) - 1) * num_states + state_idx)]) + (obs_idx == 0) * log(1.0f / num_states);

  float trans_next_logp = (obs_idx != N - 1) * log(trans_p_matrix[hook(1, state_idx * num_states + (states[ohook(0, obs_idx + 1 * (obs_idx != N - 1)) - 1))]) + (obs_idx == N - 1) * log(1.0f);

  state_logp[hook(2, obs_idx * num_states + state_idx)] = trans_prev_logp + trans_next_logp;
}