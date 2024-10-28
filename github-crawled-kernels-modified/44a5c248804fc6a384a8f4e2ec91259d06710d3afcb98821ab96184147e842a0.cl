//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_short16(global short* pin, global short* pout) {
  int x = get_global_id(0);
  short16 value;
  value = vload16(x, pin);
  value += (short16){(short)1, (short)2, (short)3, (short)4, (short)5, (short)6, (short)7, (short)8, (short)9, (short)10, (short)11, (short)12, (short)13, (short)14, (short)15, (short)16};
  vstore16(value, x, pout);
}