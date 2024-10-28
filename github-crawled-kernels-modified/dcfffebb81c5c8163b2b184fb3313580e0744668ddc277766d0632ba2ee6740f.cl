//{"K":9,"a":14,"arr":11,"cov_dets":6,"cov_invs":7,"dim":10,"group_Ns":1,"group_start_idx":2,"group_states":3,"joint_logp":8,"logp":12,"means":5,"obs":0,"p":13,"trans_p":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sum(global float* arr, int start, int length) {
  float result = 0;
  for (int i = start; i < start + length; i++) {
    result += arr[hook(11, i)];
  }
  return result;
}

float max_arr(global float* arr, int start, int length) {
  float result = arr[hook(11, start)];
  for (int i = start + 1; i < start + length; i++) {
    result = fmax(result, arr[hook(11, i)]);
  }
  return result;
}

void lognormalize(global float* logp, int start, int length) {
  float m = max_arr(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(12, i)] = powr(exp(1.0f), logp[hook(12, i)] - m);
  }
  float p_sum = sum(logp, start, length);
  for (int i = start; i < start + length; i++) {
    logp[hook(12, i)] = logp[hook(12, i)] / p_sum;
  }
}

unsigned int sample(unsigned int a_size, global unsigned int* a, global float* p, int start, float rand) {
  float total = 0.0f;
  for (unsigned int i = start; i < start + a_size; i++) {
    total = total + p[hook(13, i)];
    if (total > rand)
      return a[hook(14, i - start)];
  }
  return a[hook(14, a_size - 1)];
}

kernel void calc_joint_logp(global float* obs, global unsigned int* group_Ns, global unsigned int* group_start_idx, global unsigned int* group_states, global float* trans_p, global float* means, global float* cov_dets, global float* cov_invs, global float* joint_logp, unsigned int K, unsigned int dim) {
  unsigned int group_idx = get_global_id(0);
  unsigned int within_group_obs_idx = get_global_id(1);

  if (within_group_obs_idx >= group_Ns[hook(1, group_idx)])
    return;

  unsigned int obs_idx = group_start_idx[hook(2, group_idx)] + within_group_obs_idx;
  unsigned int state_idx = group_states[hook(3, obs_idx)] - 1;

  float logp = 0;
  logp += dim * log(2 * 3.14159265358979323846264338327950288f) + log(cov_dets[hook(6, state_idx)]);

  float mat_mul = 0.0f;
  float mat_inner;
  for (unsigned int i = 0; i < dim; i++) {
    mat_inner = 0.0f;
    for (unsigned int j = 0; j < dim; j++) {
      mat_inner += (obs[hook(0, obs_idx * dim + j)] - means[hook(5, state_idx * dim + j)]) * cov_invs[hook(7, state_idx * dim * dim + j * dim + i)];
    }
    mat_mul += mat_inner * (obs[hook(0, obs_idx * dim + i)] - means[hook(5, state_idx * dim + i)]);
  }
  logp = -0.5f * (logp + mat_mul);

  unsigned int prev_state_idx = group_states[hook(3, (obs_idx - 1) * (within_group_obs_idx > 0))] - 1;
  logp = logp + (within_group_obs_idx > 0) * log(trans_p[hook(4, prev_state_idx * K + state_idx)]) + (within_group_obs_idx == 0) * log(1.0f / K);
  joint_logp[hook(8, obs_idx)] = logp;
}