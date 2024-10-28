//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global short4* out, global short4* in) {
  *out = clamp(*in, (short4)7, (short4)42);
}