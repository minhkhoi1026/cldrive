//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_ushort3(global ushort* pin, global ushort* pout) {
  int x = get_global_id(0);
  ushort3 value;
  value = vload3(x, pin);
  value += (ushort3){(ushort)1, (ushort)2, (ushort)3};
  vstore3(value, x, pout);
}