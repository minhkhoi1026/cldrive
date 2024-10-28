//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global int2* out, global int2* in) {
  *out = clamp(*in, (int2)7, (int2)42);
}