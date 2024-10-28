//{"a0":0,"b0":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_arg_1_1_kern(global int* a0, global int* b0) {
  unsigned int gtid = get_global_id(0);
  int tmp0 = a0[hook(0, gtid)] + 0;
  b0[hook(1, gtid)] = (0 + 1) * (+tmp0);
}