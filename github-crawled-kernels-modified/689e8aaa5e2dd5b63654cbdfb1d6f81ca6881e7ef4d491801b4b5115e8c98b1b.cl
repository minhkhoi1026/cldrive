//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_uchar8(global uchar* pin, global uchar* pout) {
  int x = get_global_id(0);
  uchar8 value;
  value = vload8(x, pin);
  value += (uchar8){(uchar)1, (uchar)2, (uchar)3, (uchar)4, (uchar)5, (uchar)6, (uchar)7, (uchar)8};
  vstore8(value, x, pout);
}