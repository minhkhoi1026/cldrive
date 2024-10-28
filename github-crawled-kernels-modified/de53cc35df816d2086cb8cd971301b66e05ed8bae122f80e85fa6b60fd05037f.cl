//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global int4* out, global int4* in) {
  *out = clamp(*in, (int4)7, (int4)42);
}