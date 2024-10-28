//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global uint4* out, global uint4* in) {
  *out = clamp(*in, (uint4)7, (uint4)42);
}