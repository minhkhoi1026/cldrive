//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_long2(global long* pin, global long* pout) {
  int x = get_global_id(0);
  long2 value;
  value = vload2(x, pin);
  value += (long2){(long)1, (long)2};
  vstore2(value, x, pout);
}