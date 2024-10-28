//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_int8(global int* pin, global int* pout) {
  int x = get_global_id(0);
  int8 value;
  value = vload8(x, pin);
  value += (int8){(int)1, (int)2, (int)3, (int)4, (int)5, (int)6, (int)7, (int)8};
  vstore8(value, x, pout);
}