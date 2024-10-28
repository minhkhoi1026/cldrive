//{"alpha_d":1,"b_d":3,"nstates":0,"obs_t":4,"offset":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calc_alpha_dev(int nstates, global float* alpha_d, int offset, global float* b_d, int obs_t) {
  unsigned int idx = get_group_id(0) * get_local_size(0) + get_local_id(0);

  if (idx < nstates) {
    alpha_d[hook(1, offset + idx)] = alpha_d[hook(1, offset + idx)] * b_d[hook(3, (obs_t * nstates) + idx)];
  }
}