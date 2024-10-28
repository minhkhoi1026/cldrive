//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_float16(global float* pin, global float* pout) {
  int x = get_global_id(0);
  float16 value;
  value = vload16(x, pin);
  value += (float16){(float)1, (float)2, (float)3, (float)4, (float)5, (float)6, (float)7, (float)8, (float)9, (float)10, (float)11, (float)12, (float)13, (float)14, (float)15, (float)16};
  vstore16(value, x, pout);
}