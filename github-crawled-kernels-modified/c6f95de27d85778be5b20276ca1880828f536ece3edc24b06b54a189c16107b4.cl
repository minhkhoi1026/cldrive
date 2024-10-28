//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_double4(global double* pin, global double* pout) {
  int x = get_global_id(0);
  double4 value;
  value = vload4(x, pin);
  value += (double4){(double)1, (double)2, (double)3, (double)4};
  vstore4(value, x, pout);
}