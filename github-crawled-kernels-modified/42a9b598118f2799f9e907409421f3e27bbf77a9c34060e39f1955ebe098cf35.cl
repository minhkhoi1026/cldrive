//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global unsigned int* out, global unsigned int* in) {
  *out = clamp(*in, (unsigned int)7, (unsigned int)42);
}