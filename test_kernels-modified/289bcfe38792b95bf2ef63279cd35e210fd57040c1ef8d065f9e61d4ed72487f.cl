//{"d_out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void invalid_float3_kernel(global float3* d_out) {
  const unsigned int gidx = get_global_id(0);
  d_out[hook(0, gidx)] = (float3)(__builtin_astype((2147483647), float), __builtin_astype((2147483647), float), __builtin_astype((2147483647), float));
}