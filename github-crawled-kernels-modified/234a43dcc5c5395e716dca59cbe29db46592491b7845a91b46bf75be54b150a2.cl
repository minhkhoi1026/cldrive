//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_char4(global char* pin, global char* pout) {
  int x = get_global_id(0);
  char4 value;
  value = vload4(x, pin);
  value += (char4){(char)1, (char)2, (char)3, (char)4};
  vstore4(value, x, pout);
}