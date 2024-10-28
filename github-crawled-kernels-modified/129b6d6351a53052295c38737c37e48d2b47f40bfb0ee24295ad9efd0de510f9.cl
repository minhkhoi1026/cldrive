//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_ulong4(global ulong* pin, global ulong* pout) {
  int x = get_global_id(0);
  ulong4 value;
  value = vload4(x, pin);
  value += (ulong4){(ulong)1, (ulong)2, (ulong)3, (ulong)4};
  vstore4(value, x, pout);
}