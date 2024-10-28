//{"c":0,"c2":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_signed_char(char c, char4 c2, global char* out) {
  *out = c;
  vstore4(c2, 4, out);
}