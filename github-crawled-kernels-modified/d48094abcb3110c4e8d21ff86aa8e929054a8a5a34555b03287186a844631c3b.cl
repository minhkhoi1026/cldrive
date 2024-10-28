//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global long2* out, global long2* in) {
  *out = clamp(*in, (long2)7, (long2)42);
}