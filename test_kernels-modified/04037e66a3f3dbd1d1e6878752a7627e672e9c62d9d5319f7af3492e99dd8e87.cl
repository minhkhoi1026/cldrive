//{"_buf0":0,"_buf1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void adjacent_difference(global int* _buf0, global int* _buf1) {
  const unsigned int i = get_global_id(0);
  if (i == 0) {
    _buf0[hook(0, 0)] = _buf1[hook(1, 0)];
  } else {
    _buf0[hook(0, i)] = ((_buf1[hook(1, i)]) - (_buf1[hook(1, i - 1)]));
  }
}