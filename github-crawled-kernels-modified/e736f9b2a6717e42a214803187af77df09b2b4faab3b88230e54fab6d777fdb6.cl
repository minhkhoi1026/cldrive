//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_double16(global double* pin, global double* pout) {
  int x = get_global_id(0);
  double16 value;
  value = vload16(x, pin);
  value += (double16){(double)1, (double)2, (double)3, (double)4, (double)5, (double)6, (double)7, (double)8, (double)9, (double)10, (double)11, (double)12, (double)13, (double)14, (double)15, (double)16};
  vstore16(value, x, pout);
}