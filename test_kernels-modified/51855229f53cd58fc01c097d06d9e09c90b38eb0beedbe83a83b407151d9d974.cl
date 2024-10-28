//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant const sampler_t g_sampler = 0x10 | 0 | 2;
kernel void halve(global float4* input, global float4* output) {
  unsigned int global_addr = get_global_id(0);
  output[hook(1, global_addr)] = input[hook(0, global_addr)] / 2;
}