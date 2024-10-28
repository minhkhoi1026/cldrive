//{"_buf0":2,"_buf1":3,"size":0,"unique_count":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void serial_unique_copy(const unsigned int size, global unsigned int* unique_count, global int* _buf0, global int* _buf1) {
  unsigned int index = 0;

  int current = _buf0[hook(2, 0)];

  _buf1[hook(3, 0)] = current;

  for (unsigned int i = 1; i < size; i++) {
    int next = _buf0[hook(2, i)];

    if (!((current) == (next))) {
      _buf1[hook(3, ++index)] = next;

      current = next;
    }
  }

  *unique_count = index + 1;
}