//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_short8(global short* pin, global short* pout) {
  int x = get_global_id(0);
  short8 value;
  value = vload8(x, pin);
  value += (short8){(short)1, (short)2, (short)3, (short)4, (short)5, (short)6, (short)7, (short)8};
  vstore8(value, x, pout);
}