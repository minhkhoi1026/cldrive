//{"f":0,"f2":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_float(float f, float4 f2, global float* out) {
  *out = f;
  vstore4(f2, 4, out);
}