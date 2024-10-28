//{"_buf0":0,"_buf1":1,"_buf2":2,"count":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void subtract_ranges(global int* _buf0, global int* _buf1, global int* _buf2, const unsigned int count) {
  unsigned int index = get_local_id(0) + (32 * get_group_id(0));
  for (unsigned int i = 0; i < 4; i++) {
    if (index < count) {
      _buf0[hook(0, index)] = ((_buf1[hook(1, index)]) - (_buf2[hook(2, index)]));
      index += 8;
    }
  }
}