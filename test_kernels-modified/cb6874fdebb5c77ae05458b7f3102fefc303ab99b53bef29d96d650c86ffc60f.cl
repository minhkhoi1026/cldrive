//{"alpha":1,"n":0,"y":4,"y_offset":3,"y_raw_ptr":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void caffe_gpu_memset(const unsigned int n, const char alpha, global char* y_raw_ptr, const unsigned int y_offset) {
  global char* y = y_raw_ptr + y_offset;
  for (unsigned int index = get_global_id(0); index < (n); index += get_global_size(0)) {
    y[hook(4, index)] = alpha;
  }
}