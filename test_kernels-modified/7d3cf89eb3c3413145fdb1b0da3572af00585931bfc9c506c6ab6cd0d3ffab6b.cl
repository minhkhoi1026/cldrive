//{"b_d":1,"beta_d":0,"nstates":3,"obs_t":4,"scale_t":2,"t":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calc_beta_dev(global float* beta_d, global float* b_d, float scale_t, int nstates, int obs_t, int t) {
  unsigned int idx = get_group_id(0) * get_local_size(0) + get_local_id(0);

  if (idx < nstates) {
    beta_d[hook(0, (t * nstates) + idx)] = beta_d[hook(0, ((t + 1) * nstates) + idx)] * b_d[hook(1, (obs_t * nstates) + idx)] / scale_t;
  }
}