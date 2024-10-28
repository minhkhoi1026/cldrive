//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_uchar2(global uchar* pin, global uchar* pout) {
  int x = get_global_id(0);
  uchar2 value;
  value = vload2(x, pin);
  value += (uchar2){(uchar)1, (uchar)2};
  vstore2(value, x, pout);
}