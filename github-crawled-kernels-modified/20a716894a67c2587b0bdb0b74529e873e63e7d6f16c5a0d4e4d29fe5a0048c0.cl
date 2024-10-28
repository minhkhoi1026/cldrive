//{"_buf0":2,"_buf1":3,"_buf2":4,"_buf3":5,"count":0,"result_size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void serial_reduce_by_key(unsigned int count, global unsigned int* result_size, global int* _buf0, global int* _buf1, global int* _buf2, global int* _buf3) {
  int result = _buf0[hook(2, 0)];
  int previous_key = _buf1[hook(3, 0)];
  int value;
  int key;
  unsigned int size = 1;
  _buf2[hook(4, 0)] = previous_key;
  _buf3[hook(5, 0)] = result;
  for (ulong i = 1; i < count; i++) {
    value = _buf0[hook(2, i)];
    key = _buf1[hook(3, i)];
    if (((previous_key) == (key))) {
      result = ((result) + (value));
    } else {
      _buf2[hook(4, size - 1)] = previous_key;
      _buf3[hook(5, size - 1)] = result;
      result = value;
      size++;
    }
    previous_key = key;
  }
  _buf2[hook(4, size - 1)] = previous_key;
  _buf3[hook(5, size - 1)] = result;
  *result_size = size;
}