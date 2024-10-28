//{"a_d":0,"c_d":1,"nstates":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scale_a_dev(global float* a_d, global float* c_d, int nstates) {
  unsigned int idx = get_group_id(0) * get_local_size(0) + get_local_id(0);

  unsigned int idy = get_group_id(1) * get_local_size(1) + get_local_id(1);

  if (idx < nstates && idy < nstates) {
    a_d[hook(0, (idy * nstates) + idx)] = a_d[hook(0, (idy * nstates) + idx)] / c_d[hook(1, idy)];
  }
}