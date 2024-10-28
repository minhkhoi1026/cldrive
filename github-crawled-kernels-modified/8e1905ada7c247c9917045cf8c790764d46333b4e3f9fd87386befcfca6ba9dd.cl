//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_long16(global long* pin, global long* pout) {
  int x = get_global_id(0);
  long16 value;
  value = vload16(x, pin);
  value += (long16){(long)1, (long)2, (long)3, (long)4, (long)5, (long)6, (long)7, (long)8, (long)9, (long)10, (long)11, (long)12, (long)13, (long)14, (long)15, (long)16};
  vstore16(value, x, pout);
}