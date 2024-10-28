//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_template_empty0(global int const* const input, global int* const output) {
  __asm__("");
  output[hook(1, get_global_id(0))] = 0;
}