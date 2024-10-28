//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_clamp(global uchar* out, global uchar* in) {
  *out = clamp(*in, (uchar)7, (uchar)42);
}