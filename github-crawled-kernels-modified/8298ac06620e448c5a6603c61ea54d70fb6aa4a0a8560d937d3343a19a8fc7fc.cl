//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global ushort2* out, global ushort2* in) {
  *out = clamp(*in, (ushort2)7, (ushort2)42);
}