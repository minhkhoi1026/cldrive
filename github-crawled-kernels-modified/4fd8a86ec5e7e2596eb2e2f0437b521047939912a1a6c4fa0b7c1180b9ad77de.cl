//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_ulong3(global ulong* pin, global ulong* pout) {
  int x = get_global_id(0);
  ulong3 value;
  value = vload3(x, pin);
  value += (ulong3){(ulong)1, (ulong)2, (ulong)3};
  vstore3(value, x, pout);
}