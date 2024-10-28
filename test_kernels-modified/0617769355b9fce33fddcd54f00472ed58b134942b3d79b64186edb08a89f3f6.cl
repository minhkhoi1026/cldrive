//{"_buf0":1,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void adjacent_find_with_atomics(global unsigned int* output, global int* _buf0) {
  const unsigned int i = get_global_id(0);
  if (_buf0[hook(1, i)] == _buf0[hook(1, i + 1)]) {
    atomic_min(output, i);
  }
}