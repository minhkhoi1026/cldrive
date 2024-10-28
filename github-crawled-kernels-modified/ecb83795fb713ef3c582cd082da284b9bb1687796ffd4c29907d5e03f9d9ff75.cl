//{"beta_d":1,"nstates":0,"offset":2,"scale":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void init_beta_dev(int nstates, global float* beta_d, int offset, float scale) {
  unsigned int idx = get_group_id(0) * get_local_size(0) + get_local_id(0);

  if (idx < nstates) {
    beta_d[hook(1, offset + idx)] = 1.0f / scale;
  }
}