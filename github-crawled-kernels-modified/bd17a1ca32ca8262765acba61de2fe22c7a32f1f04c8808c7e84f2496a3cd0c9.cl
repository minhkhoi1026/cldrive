//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_uchar16(global uchar* pin, global uchar* pout) {
  int x = get_global_id(0);
  uchar16 value;
  value = vload16(x, pin);
  value += (uchar16){(uchar)1, (uchar)2, (uchar)3, (uchar)4, (uchar)5, (uchar)6, (uchar)7, (uchar)8, (uchar)9, (uchar)10, (uchar)11, (uchar)12, (uchar)13, (uchar)14, (uchar)15, (uchar)16};
  vstore16(value, x, pout);
}