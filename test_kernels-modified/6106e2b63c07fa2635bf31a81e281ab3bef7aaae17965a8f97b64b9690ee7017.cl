//{"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
extern int test_function();
kernel void test_kernel(global int* out) {
  out[hook(0, 0)] = test_function();
}