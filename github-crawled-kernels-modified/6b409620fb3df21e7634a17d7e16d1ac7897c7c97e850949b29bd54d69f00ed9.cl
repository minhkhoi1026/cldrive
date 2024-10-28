//{"in":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_kernel(global int* in) {
  printf("%i", *((int*)0x00ff00ff));
}