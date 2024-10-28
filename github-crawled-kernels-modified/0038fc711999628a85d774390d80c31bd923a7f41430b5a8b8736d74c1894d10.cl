//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_int16(global int* pin, global int* pout) {
  int x = get_global_id(0);
  int16 value;
  value = vload16(x, pin);
  value += (int16){(int)1, (int)2, (int)3, (int)4, (int)5, (int)6, (int)7, (int)8, (int)9, (int)10, (int)11, (int)12, (int)13, (int)14, (int)15, (int)16};
  vstore16(value, x, pout);
}