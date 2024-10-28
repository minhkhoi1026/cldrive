//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global ulong4* out, global ulong4* in) {
  *out = clamp(*in, (ulong4)7, (ulong4)42);
}