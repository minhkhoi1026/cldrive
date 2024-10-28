//{"outputValues":1,"values":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void GPUTester_kernel(global float* values, global float* outputValues) {
  size_t i = get_global_id(0);
  size_t j = get_global_id(1);

  size_t pos = i + get_global_size(0) * j;

  outputValues[hook(1, pos)] = pos * 1;
}