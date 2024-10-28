//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_long4(global long* pin, global long* pout) {
  int x = get_global_id(0);
  long4 value;
  value = vload4(x, pin);
  value += (long4){(long)1, (long)2, (long)3, (long)4};
  vstore4(value, x, pout);
}