//{"nsymbols":1,"ones_s_d":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void init_ones_dev(global float* ones_s_d, int nsymbols) {
  unsigned int idx = get_group_id(0) * get_local_size(0) + get_local_id(0);

  if (idx < nsymbols) {
    ones_s_d[hook(0, idx)] = 1.0f;
  }
}