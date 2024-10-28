//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global int3* out, global int3* in) {
  *out = clamp(*in, (int3)7, (int3)42);
}