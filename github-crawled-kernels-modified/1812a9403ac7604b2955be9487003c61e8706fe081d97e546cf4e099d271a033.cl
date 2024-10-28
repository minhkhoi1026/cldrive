//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global uint3* out, global uint3* in) {
  *out = clamp(*in, (uint3)7, (uint3)42);
}