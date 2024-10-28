//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_int2(global int* pin, global int* pout) {
  int x = get_global_id(0);
  int2 value;
  value = vload2(x, pin);
  value += (int2){(int)1, (int)2};
  vstore2(value, x, pout);
}