//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_long3(global long* pin, global long* pout) {
  int x = get_global_id(0);
  long3 value;
  value = vload3(x, pin);
  value += (long3){(long)1, (long)2, (long)3};
  vstore3(value, x, pout);
}