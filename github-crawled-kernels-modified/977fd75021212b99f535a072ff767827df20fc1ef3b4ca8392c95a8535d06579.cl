//{"i":0,"i2":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_signed_int(int i, int4 i2, global int* out) {
  *out = i;
  vstore4(i2, 4, out);
}