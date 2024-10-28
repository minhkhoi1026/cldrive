//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_char3(global char* pin, global char* pout) {
  int x = get_global_id(0);
  char3 value;
  value = vload3(x, pin);
  value += (char3){(char)1, (char)2, (char)3};
  vstore3(value, x, pout);
}