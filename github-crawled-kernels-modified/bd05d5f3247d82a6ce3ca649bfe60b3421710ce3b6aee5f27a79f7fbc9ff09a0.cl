//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_ulong16(global ulong* pin, global ulong* pout) {
  int x = get_global_id(0);
  ulong16 value;
  value = vload16(x, pin);
  value += (ulong16){(ulong)1, (ulong)2, (ulong)3, (ulong)4, (ulong)5, (ulong)6, (ulong)7, (ulong)8, (ulong)9, (ulong)10, (ulong)11, (ulong)12, (ulong)13, (ulong)14, (ulong)15, (ulong)16};
  vstore16(value, x, pout);
}