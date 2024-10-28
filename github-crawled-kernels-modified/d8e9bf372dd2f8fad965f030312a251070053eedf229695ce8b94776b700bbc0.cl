//{"_buf0":2,"output":1,"size":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void serial_adjacent_find(const unsigned int size, global unsigned int* output, global char* _buf0) {
  unsigned int result = size;
  for (unsigned int i = 0; i < size - 1; i++) {
    if (((_buf0[hook(2, i + 1)]) < (_buf0[hook(2, i)]))) {
      result = i;
      break;
    }
  }
  *output = result;
}