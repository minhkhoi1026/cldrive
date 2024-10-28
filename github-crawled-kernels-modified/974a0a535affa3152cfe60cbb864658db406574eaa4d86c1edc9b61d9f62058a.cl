//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_double8(global double* pin, global double* pout) {
  int x = get_global_id(0);
  double8 value;
  value = vload8(x, pin);
  value += (double8){(double)1, (double)2, (double)3, (double)4, (double)5, (double)6, (double)7, (double)8};
  vstore8(value, x, pout);
}