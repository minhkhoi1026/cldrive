//{"_buf0":1,"index":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void find_if(global int* index, global int* _buf0) {
  const unsigned int i = get_global_id(0);
  const int value = _buf0[hook(1, 1167 + (i))];
  if (value >= 3) {
    atomic_min(index, i);
  }
}