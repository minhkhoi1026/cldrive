//{"a":9,"arr":6,"cov_dets":2,"cov_invs":3,"dim":5,"emit_logp":4,"logp":7,"means":1,"obs":0,"p":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sum(global float* arr, int start, int length) {
  float result = 0;
  for (int i = start; i < start + length; i++) {
    result += arr[hook(6, i)];
  }
  return result;
}

float max_arr(global float* arr, int start, int length) {
  float result = arr[hook(6, start)];
  for (int i = start + 1; i < start + length; i++) {
    result = fmax(result, arr[hook(6, i)]);
  }
  return result;
}

void lognormalize(global float* logp, int start, int length) {
  float m = max_arr(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(7, i)] = powr(exp(1.0f), logp[hook(7, i)] - m);
  }
  float p_sum = sum(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(7, i)] = logp[hook(7, i)] / p_sum;
  }
}

unsigned int sample(unsigned int a_size, global unsigned int* a, global float* p, int start, float rand) {
  float total = 0.0f;
  for (unsigned int i = start; i < start + a_size; i++) {
    total = total + p[hook(8, i)];
    if (total > rand)
      return a[hook(9, i - start)];
  }
  return a[hook(9, a_size - 1)];
}

kernel void calc_emit_logp(global float* obs, global float* means, global float* cov_dets, global float* cov_invs, global float* emit_logp, unsigned int dim) {
  unsigned int obs_idx = get_global_id(0);
  unsigned int state_idx = get_global_id(1);
  unsigned int K = get_global_size(1);

  float logp = 0;
  logp += dim * log(2 * 3.14159265358979323846264338327950288f) + log(cov_dets[hook(2, state_idx)]);

  float mat_mul = 0.0f;
  float mat_inner;
  for (unsigned int i = 0; i < dim; i++) {
    mat_inner = 0.0f;
    for (unsigned int j = 0; j < dim; j++) {
      mat_inner += (obs[hook(0, obs_idx * dim + j)] - means[hook(1, state_idx * dim + j)]) * cov_invs[hook(3, state_idx * dim * dim + j * dim + i)];
    }
    mat_mul += mat_inner * (obs[hook(0, obs_idx * dim + i)] - means[hook(1, state_idx * dim + i)]);
  }

  emit_logp[hook(4, obs_idx * K + state_idx)] = -0.5f * (logp + mat_mul);
}