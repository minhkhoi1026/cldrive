//{"_buf0":2,"result":1,"size":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void serial_count_if_vector_equal(unsigned int size, global unsigned int* result, global int4* _buf0) {
  unsigned int count = 0;
  for (unsigned int i = 0; i < size; i++) {
    const int4 value = _buf0[hook(2, i)];
    if (all(value == (int4)(0, 1, 2, 3))) {
      count++;
    }
  }
  *result = count;
}