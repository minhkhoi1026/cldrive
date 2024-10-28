//{"batch":2,"px":0,"py":3,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void batch_sum_fw_kernel(const global float* px, const unsigned size, const unsigned batch, global float* py) {
  const unsigned i = get_global_id(0);
  if (i < size) {
    float temp = .0f;
    px += i;
    for (unsigned j = 0; j < batch; ++j, px += size) {
      temp += *px;
    }
    py[hook(3, i)] = temp;
  }
}