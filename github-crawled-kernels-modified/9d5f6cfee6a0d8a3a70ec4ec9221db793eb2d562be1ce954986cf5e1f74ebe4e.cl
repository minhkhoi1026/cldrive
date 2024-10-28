//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global uchar3* out, global uchar3* in) {
  *out = clamp(*in, (uchar3)7, (uchar3)42);
}