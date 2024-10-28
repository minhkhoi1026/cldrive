//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_double2(global double* pin, global double* pout) {
  int x = get_global_id(0);
  double2 value;
  value = vload2(x, pin);
  value += (double2){(double)1, (double)2};
  vstore2(value, x, pout);
}