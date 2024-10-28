//{"alpha_d":1,"b_d":0,"beta_d":2,"nstates":4,"nsymbols":5,"obs_t":6,"sum_ab":3,"t":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void acc_b_dev(global float* b_d, global float* alpha_d, global float* beta_d, float sum_ab, int nstates, int nsymbols, int obs_t, int t) {
  unsigned int idx = get_group_id(0) * get_local_size(0) + get_local_id(0);

  unsigned int idy = get_group_id(1) * get_local_size(1) + get_local_id(1);

  if (idy < nsymbols && idx < nstates && obs_t == idy) {
    b_d[hook(0, (idy * nstates) + idx)] += alpha_d[hook(1, (t * nstates) + idx)] * beta_d[hook(2, (t * nstates) + idx)] / sum_ab;
  }
}