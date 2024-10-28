//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_uchar3(global uchar* pin, global uchar* pout) {
  int x = get_global_id(0);
  uchar3 value;
  value = vload3(x, pin);
  value += (uchar3){(uchar)1, (uchar)2, (uchar)3};
  vstore3(value, x, pout);
}