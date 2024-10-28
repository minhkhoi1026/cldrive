//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global long4* out, global long4* in) {
  *out = clamp(*in, (long4)7, (long4)42);
}