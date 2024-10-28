//{"b_d":0,"c_d":1,"nstates":2,"nsymbols":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scale_b_dev(global float* b_d, global float* c_d, int nstates, int nsymbols) {
  unsigned int idx = get_group_id(0) * get_local_size(0) + get_local_id(0);

  unsigned int idy = get_group_id(1) * get_local_size(1) + get_local_id(1);

  if (idx < nstates && idy < nsymbols) {
    if (b_d[hook(0, (idx * nsymbols) + idy)] == 0) {
      b_d[hook(0, (idx * nsymbols) + idy)] = 1e-10;
    } else {
      b_d[hook(0, (idx * nsymbols) + idy)] = b_d[hook(0, (idx * nsymbols) + idy)] / c_d[hook(1, idx)];
    }
  }
}