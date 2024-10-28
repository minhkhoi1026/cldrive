//{"_buf0":2,"block":1,"index":0,"needle":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void binary_find(global unsigned int* index, unsigned int block, global int* _buf0, unsigned int needle) {
  unsigned int i = get_global_id(0) * block;
  int value = _buf0[hook(2, i)];
  if (value >= needle) {
    atomic_min(index, i);
  }
}