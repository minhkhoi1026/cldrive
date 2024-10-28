//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global ulong3* out, global ulong3* in) {
  *out = clamp(*in, (ulong3)7, (ulong3)42);
}