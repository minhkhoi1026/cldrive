//{"dev_buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void samplecl_kernel(global unsigned int* dev_buf) {
  const size_t width = get_global_size(0);
  const size_t i = get_global_id(0);
  const size_t j = get_global_id(1);
  const size_t index = i + j * width;

  dev_buf[hook(0, index)] = index;
}