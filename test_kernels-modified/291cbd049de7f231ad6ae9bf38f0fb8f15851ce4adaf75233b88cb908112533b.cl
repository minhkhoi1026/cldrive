//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void SimpleKernel4(const global float4* input, global float4* output) {
  size_t index = get_global_id(0);
  output[hook(1, index)] = rsqrt(fabs(input[hook(0, index)]));
}