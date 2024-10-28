//{"px":0,"py":3,"shift":1,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void batch_slice_fw_kernel(const global float* px, const unsigned shift, const unsigned size, global float* py) {
  const unsigned i = get_global_id(0);
  if (i < size)
    py[hook(3, i)] = px[hook(0, i + shift)];
}