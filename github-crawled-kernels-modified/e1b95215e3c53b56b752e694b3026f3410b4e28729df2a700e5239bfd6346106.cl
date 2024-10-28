//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_ulong2(global ulong* pin, global ulong* pout) {
  int x = get_global_id(0);
  ulong2 value;
  value = vload2(x, pin);
  value += (ulong2){(ulong)1, (ulong)2};
  vstore2(value, x, pout);
}