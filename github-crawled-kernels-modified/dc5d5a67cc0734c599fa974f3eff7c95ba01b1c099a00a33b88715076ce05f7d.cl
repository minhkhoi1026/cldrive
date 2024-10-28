//{"px":0,"py":2,"shift":3,"y_size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void batch_concat_fw_kernel(const global float* px, const unsigned y_size, global float* py, const unsigned shift) {
  const unsigned i = get_global_id(0);
  if (i < y_size)
    py[hook(2, i + shift)] = px[hook(0, i)];
}