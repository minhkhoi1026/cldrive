//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global char4* out, global char4* in) {
  *out = clamp(*in, (char4)7, (char4)42);
}