//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global long3* out, global long3* in) {
  *out = clamp(*in, (long3)7, (long3)42);
}