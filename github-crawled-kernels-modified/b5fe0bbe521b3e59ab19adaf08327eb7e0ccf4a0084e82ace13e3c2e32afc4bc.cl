//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_ushort2(global ushort* pin, global ushort* pout) {
  int x = get_global_id(0);
  ushort2 value;
  value = vload2(x, pin);
  value += (ushort2){(ushort)1, (ushort)2};
  vstore2(value, x, pout);
}