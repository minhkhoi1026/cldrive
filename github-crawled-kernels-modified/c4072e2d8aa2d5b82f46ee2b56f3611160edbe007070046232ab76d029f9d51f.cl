//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int test_const_attr(int a) {
  return max(a, 2);
}

kernel void test_mangling() {
  size_t lid = get_local_id(0);
}