//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant unsigned int constant_var = 0;
kernel void test(void) {
  local unsigned int local_var;
  local_var = 0;
}