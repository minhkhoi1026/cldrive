//{"alpha_d":1,"beta_d":2,"nstates":4,"pi_d":0,"sum_ab":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void est_pi_dev(global float* pi_d, global float* alpha_d, global float* beta_d, float sum_ab, int nstates) {
  unsigned int idx = get_group_id(0) * get_local_size(0) + get_local_id(0);

  if (idx < nstates) {
    pi_d[hook(0, idx)] = alpha_d[hook(1, idx)] * beta_d[hook(2, idx)] / sum_ab;
  }
}