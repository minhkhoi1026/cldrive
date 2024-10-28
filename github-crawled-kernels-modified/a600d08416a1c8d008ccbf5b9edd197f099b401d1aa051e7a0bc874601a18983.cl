//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_int4(global int* pin, global int* pout) {
  int x = get_global_id(0);
  int4 value;
  value = vload4(x, pin);
  value += (int4){(int)1, (int)2, (int)3, (int)4};
  vstore4(value, x, pout);
}