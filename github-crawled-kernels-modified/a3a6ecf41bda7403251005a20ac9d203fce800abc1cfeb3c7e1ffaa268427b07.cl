//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_short4(global short* pin, global short* pout) {
  int x = get_global_id(0);
  short4 value;
  value = vload4(x, pin);
  value += (short4){(short)1, (short)2, (short)3, (short)4};
  vstore4(value, x, pout);
}