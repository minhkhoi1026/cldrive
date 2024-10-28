//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_short2(global short* pin, global short* pout) {
  int x = get_global_id(0);
  short2 value;
  value = vload2(x, pin);
  value += (short2){(short)1, (short)2};
  vstore2(value, x, pout);
}