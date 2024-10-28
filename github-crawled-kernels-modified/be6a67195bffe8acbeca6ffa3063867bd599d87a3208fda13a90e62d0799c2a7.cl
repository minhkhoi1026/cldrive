//{"ext_a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_kernel(int ext_a) {
  int a = ext_a;
  int* b = &a + 1;
  printf("%i,%i", *(&a + 1), *(b - 1));
}