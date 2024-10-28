//{"alpha_d":1,"nstates":0,"offset":2,"scale":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scale_alpha_dev(int nstates, global float* alpha_d, int offset, float scale) {
  unsigned int idx = get_group_id(0) * get_local_size(0) + get_local_id(0);

  if (idx < nstates) {
    alpha_d[hook(1, offset + idx)] = alpha_d[hook(1, offset + idx)] / scale;
  }
}