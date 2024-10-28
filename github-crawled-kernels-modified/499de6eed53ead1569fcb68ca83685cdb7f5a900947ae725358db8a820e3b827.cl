//{"_buf0":0,"_buf1":1,"_buf2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transform_if_do_copy(global int* _buf0, global int* _buf1, global unsigned int* _buf2) {
  if (!(_buf0[hook(0, get_global_id(0))] == 4))
    _buf1[hook(1, _buf2[ghook(2, get_global_id(0)))] = _buf0[hook(0, get_global_id(0))];
}