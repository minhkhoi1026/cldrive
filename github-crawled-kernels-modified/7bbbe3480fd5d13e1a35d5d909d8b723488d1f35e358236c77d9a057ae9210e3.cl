//{"_buf0":0,"index":1,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void serial_find_extrema_min(global int* _buf0, global unsigned int* index, unsigned int size) {
  int value = _buf0[hook(0, 0)];
  unsigned int value_index = 0;
  for (unsigned int i = 1; i < size; i++) {
    int candidate = _buf0[hook(0, i)];

    if (((candidate) < (value))) {
      value = candidate;
      value_index = i;
    }
  }
  *index = value_index;
}