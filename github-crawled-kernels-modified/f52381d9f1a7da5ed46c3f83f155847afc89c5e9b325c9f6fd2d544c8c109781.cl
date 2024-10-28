//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_ushort8(global ushort* pin, global ushort* pout) {
  int x = get_global_id(0);
  ushort8 value;
  value = vload8(x, pin);
  value += (ushort8){(ushort)1, (ushort)2, (ushort)3, (ushort)4, (ushort)5, (ushort)6, (ushort)7, (ushort)8};
  vstore8(value, x, pout);
}