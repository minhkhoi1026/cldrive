//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_double3(global double* pin, global double* pout) {
  int x = get_global_id(0);
  double3 value;
  value = vload3(x, pin);
  value += (double3){(double)1, (double)2, (double)3};
  vstore3(value, x, pout);
}