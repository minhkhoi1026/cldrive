//{"a_d":1,"alpha_d":3,"b_d":2,"beta_d":4,"nstates":6,"obs_t":7,"sum_ab":5,"t":8,"xi_sum_d":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calc_xi_dev(global float* xi_sum_d, global float* a_d, global float* b_d, global float* alpha_d, global float* beta_d, float sum_ab, int nstates, int obs_t, int t) {
  unsigned int idx = get_group_id(0) * get_local_size(0) + get_local_id(0);

  unsigned int idy = get_group_id(1) * get_local_size(1) + get_local_id(1);

  if (idx < nstates && idy < nstates) {
    xi_sum_d[hook(0, (idy * nstates) + idx)] += alpha_d[hook(3, (t * nstates) + idy)] * a_d[hook(1, (idy * nstates) + idx)] * b_d[hook(2, (obs_t * nstates) + idx)] * beta_d[hook(4, ((t + 1) * nstates) + idx)] / sum_ab;
  }
}