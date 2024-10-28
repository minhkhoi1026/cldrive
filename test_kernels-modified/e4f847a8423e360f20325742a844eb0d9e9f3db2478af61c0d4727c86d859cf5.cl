//{"alpha_d":1,"beta_d":2,"gamma_sum_d":0,"nstates":3,"t":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calc_gamma_dev(global float* gamma_sum_d, global float* alpha_d, global float* beta_d, int nstates, int t) {
  unsigned int idx = get_group_id(0) * get_local_size(0) + get_local_id(0);

  if (idx < nstates) {
    gamma_sum_d[hook(0, idx)] += alpha_d[hook(1, (t * nstates) + idx)] * beta_d[hook(2, (t * nstates) + idx)];
  }
}