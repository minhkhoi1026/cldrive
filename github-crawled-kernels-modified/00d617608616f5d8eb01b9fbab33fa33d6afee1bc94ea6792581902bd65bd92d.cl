//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_template_no_operands1(global int const* const input, global int* const output) {
  const size_t tid = get_global_id(0);

  int tmp = input[hook(0, tid)];

  __asm__("barrier");

  tmp = tmp << 1;

  __asm__("barrier");

  tmp += 0xa5;

  __asm__("barrier");

  output[hook(1, tid)] = tmp;
}