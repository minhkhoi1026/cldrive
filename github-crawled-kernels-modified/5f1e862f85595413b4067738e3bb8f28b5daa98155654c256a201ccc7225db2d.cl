//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global ushort4* out, global ushort4* in) {
  *out = clamp(*in, (ushort4)7, (ushort4)42);
}