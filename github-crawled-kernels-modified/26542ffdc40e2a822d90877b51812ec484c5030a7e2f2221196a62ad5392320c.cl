//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global short3* out, global short3* in) {
  *out = clamp(*in, (short3)7, (short3)42);
}