//{"a":1,"b":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_rotate(global uchar3* out, uchar3 a, uchar3 b) {
  *out = rotate(a, b);
}