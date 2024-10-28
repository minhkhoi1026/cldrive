//{"alpha_d":3,"b_d":0,"nstates":2,"obs_t":5,"ones_n_d":4,"pi_d":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void init_alpha_dev(global float* b_d, global float* pi_d, int nstates, global float* alpha_d, global float* ones_n_d, int obs_t) {
  unsigned int idx = get_group_id(0) * get_local_size(0) + get_local_id(0);

  if (idx < nstates) {
    alpha_d[hook(3, idx)] = pi_d[hook(1, idx)] * b_d[hook(0, (obs_t * nstates) + idx)];
    ones_n_d[hook(4, idx)] = 1.0f;
  }
}