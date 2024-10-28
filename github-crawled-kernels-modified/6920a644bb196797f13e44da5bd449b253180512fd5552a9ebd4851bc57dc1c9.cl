//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global ushort* out, global ushort* in) {
  *out = clamp(*in, (ushort)7, (ushort)42);
}