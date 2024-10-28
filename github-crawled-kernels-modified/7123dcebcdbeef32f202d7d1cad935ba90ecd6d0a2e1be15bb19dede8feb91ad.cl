//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_float8(global float* pin, global float* pout) {
  int x = get_global_id(0);
  float8 value;
  value = vload8(x, pin);
  value += (float8){(float)1, (float)2, (float)3, (float)4, (float)5, (float)6, (float)7, (float)8};
  vstore8(value, x, pout);
}