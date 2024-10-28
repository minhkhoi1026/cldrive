//{"a":1,"b":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_rotate(global ushort2* out, ushort2 a, ushort2 b) {
  *out = rotate(a, b);
}