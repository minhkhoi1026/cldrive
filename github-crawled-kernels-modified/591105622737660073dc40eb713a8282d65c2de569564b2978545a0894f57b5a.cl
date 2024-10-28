//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_uchar4(global uchar* pin, global uchar* pout) {
  int x = get_global_id(0);
  uchar4 value;
  value = vload4(x, pin);
  value += (uchar4){(uchar)1, (uchar)2, (uchar)3, (uchar)4};
  vstore4(value, x, pout);
}