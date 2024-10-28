//{"pin":0,"pout":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_char2(global char* pin, global char* pout) {
  int x = get_global_id(0);
  char2 value;
  value = vload2(x, pin);
  value += (char2){(char)1, (char)2};
  vstore2(value, x, pout);
}