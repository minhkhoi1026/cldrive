//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global ushort3* out, global ushort3* in) {
  *out = clamp(*in, (ushort3)7, (ushort3)42);
}