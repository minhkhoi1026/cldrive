//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global char2* out, global char2* in) {
  *out = clamp(*in, (char2)7, (char2)42);
}