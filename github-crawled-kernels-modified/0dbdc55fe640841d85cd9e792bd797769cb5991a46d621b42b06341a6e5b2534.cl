//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_long8(global long* pin, global long* pout) {
  int x = get_global_id(0);
  long8 value;
  value = vload8(x, pin);
  value += (long8){(long)1, (long)2, (long)3, (long)4, (long)5, (long)6, (long)7, (long)8};
  vstore8(value, x, pout);
}