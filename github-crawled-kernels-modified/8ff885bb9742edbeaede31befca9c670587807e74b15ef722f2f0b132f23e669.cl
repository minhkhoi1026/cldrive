//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_ushort4(global ushort* pin, global ushort* pout) {
  int x = get_global_id(0);
  ushort4 value;
  value = vload4(x, pin);
  value += (ushort4){(ushort)1, (ushort)2, (ushort)3, (ushort)4};
  vstore4(value, x, pout);
}