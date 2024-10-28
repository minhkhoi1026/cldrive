//{"a":0,"b":1,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_kernel(global float* a, global float* b, global float* output) {
  size_t idx = get_global_id(0);
  output[hook(2, idx)] = (a[hook(0, idx)]) + (b[hook(1, idx)]);
}