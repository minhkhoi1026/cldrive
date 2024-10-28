//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_ulong8(global ulong* pin, global ulong* pout) {
  int x = get_global_id(0);
  ulong8 value;
  value = vload8(x, pin);
  value += (ulong8){(ulong)1, (ulong)2, (ulong)3, (ulong)4, (ulong)5, (ulong)6, (ulong)7, (ulong)8};
  vstore8(value, x, pout);
}