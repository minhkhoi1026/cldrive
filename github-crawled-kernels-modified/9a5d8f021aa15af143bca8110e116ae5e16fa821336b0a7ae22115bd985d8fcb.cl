//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int test_func(constant char* foo);
kernel void str_array_decy() {
  test_func("Test string literal");
}