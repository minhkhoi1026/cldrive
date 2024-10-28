//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_ushort16(global ushort* pin, global ushort* pout) {
  int x = get_global_id(0);
  ushort16 value;
  value = vload16(x, pin);
  value += (ushort16){(ushort)1, (ushort)2, (ushort)3, (ushort)4, (ushort)5, (ushort)6, (ushort)7, (ushort)8, (ushort)9, (ushort)10, (ushort)11, (ushort)12, (ushort)13, (ushort)14, (ushort)15, (ushort)16};
  vstore16(value, x, pout);
}