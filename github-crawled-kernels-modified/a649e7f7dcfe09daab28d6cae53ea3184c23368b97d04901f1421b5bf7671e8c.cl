//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_short3(global short* pin, global short* pout) {
  int x = get_global_id(0);
  short3 value;
  value = vload3(x, pin);
  value += (short3){(short)1, (short)2, (short)3};
  vstore3(value, x, pout);
}