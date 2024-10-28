//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_char8(global char* pin, global char* pout) {
  int x = get_global_id(0);
  char8 value;
  value = vload8(x, pin);
  value += (char8){(char)1, (char)2, (char)3, (char)4, (char)5, (char)6, (char)7, (char)8};
  vstore8(value, x, pout);
}