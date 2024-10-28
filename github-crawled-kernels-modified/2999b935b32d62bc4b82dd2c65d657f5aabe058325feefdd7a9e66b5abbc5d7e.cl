//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_int3(global int* pin, global int* pout) {
  int x = get_global_id(0);
  int3 value;
  value = vload3(x, pin);
  value += (int3){(int)1, (int)2, (int)3};
  vstore3(value, x, pout);
}