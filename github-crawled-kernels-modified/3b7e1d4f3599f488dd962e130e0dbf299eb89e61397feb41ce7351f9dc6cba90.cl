//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_char16(global char* pin, global char* pout) {
  int x = get_global_id(0);
  char16 value;
  value = vload16(x, pin);
  value += (char16){(char)1, (char)2, (char)3, (char)4, (char)5, (char)6, (char)7, (char)8, (char)9, (char)10, (char)11, (char)12, (char)13, (char)14, (char)15, (char)16};
  vstore16(value, x, pout);
}