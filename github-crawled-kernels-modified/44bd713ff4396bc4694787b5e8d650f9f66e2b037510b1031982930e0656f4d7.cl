//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_kernel(global float* in, global float* out) {
  int i = get_global_id(0);
  float4 loaded = vload_half4(i, in);
  vstore_half4(loaded, i, out);
}