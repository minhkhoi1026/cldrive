//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global short2* out, global short2* in) {
  *out = clamp(*in, (short2)7, (short2)42);
}