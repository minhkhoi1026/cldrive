//{"chids":0,"index":2,"k":3,"lits":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prepare_index(global unsigned int* restrict chids, global unsigned int* restrict lits, global uint2* restrict index, private unsigned int k) {
  unsigned int thread = get_global_id(0);
  uint2 res;
  if (thread < k) {
    res.x = chids[hook(0, thread)];
    res.y = lits[hook(1, thread)];
    index[hook(2, thread)] = res;
  }
}