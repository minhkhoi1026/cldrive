//{"a_d":0,"alpha_d":1,"beta_d":2,"gamma_sum_d":4,"length":7,"nstates":6,"sum_ab":5,"xi_sum_d":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void est_a_dev(global float* a_d, global float* alpha_d, global float* beta_d, global float* xi_sum_d, global float* gamma_sum_d, float sum_ab, int nstates, int length) {
  unsigned int idx = get_group_id(0) * get_local_size(0) + get_local_id(0);

  unsigned int idy = get_group_id(1) * get_local_size(1) + get_local_id(1);

  if (idx < nstates && idy < nstates) {
    a_d[hook(0, (idy * nstates) + idx)] = xi_sum_d[hook(3, (idy * nstates) + idx)] / (gamma_sum_d[hook(4, idy)] - alpha_d[hook(1, (length * nstates) + idy)] * beta_d[hook(2, (length * nstates) + idy)] / sum_ab);
  }
}