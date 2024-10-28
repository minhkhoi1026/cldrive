//{"a0":0,"b0":1,"b1":2,"b2":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_arg_1_3_kern(global int* a0, global int* b0, global int* b1, global int* b2) {
  unsigned int gtid = get_global_id(0);
  int tmp0 = a0[hook(0, gtid)] + 0;
  b0[hook(1, gtid)] = (0 + 1) * (+tmp0);
  b1[hook(2, gtid)] = (1 + 1) * (+tmp0);
  b2[hook(3, gtid)] = (2 + 1) * (+tmp0);
}