//{"a":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_upsample(global short* out, char a) {
  *out = upsample(a, (uchar)42);
}