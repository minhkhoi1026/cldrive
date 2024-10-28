//{"b_d":0,"gamma_sum_d":1,"nstates":2,"nsymbols":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void est_b_dev(global float* b_d, global float* gamma_sum_d, int nstates, int nsymbols) {
  unsigned int idx = get_group_id(0) * get_local_size(0) + get_local_id(0);

  unsigned int idy = get_group_id(1) * get_local_size(1) + get_local_id(1);

  if (idy < nsymbols && idx < nstates) {
    b_d[hook(0, (idy * nstates) + idx)] = b_d[hook(0, (idy * nstates) + idx)] / gamma_sum_d[hook(1, idx)];
  }
}