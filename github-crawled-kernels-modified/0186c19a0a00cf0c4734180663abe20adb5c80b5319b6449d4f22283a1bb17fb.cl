//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void foo(void);
void foo2(void);
kernel void declared_function_test(void) {
  foo();
}