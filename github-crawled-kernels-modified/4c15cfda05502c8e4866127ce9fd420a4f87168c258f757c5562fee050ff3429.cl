//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global ulong2* out, global ulong2* in) {
  *out = clamp(*in, (ulong2)7, (ulong2)42);
}