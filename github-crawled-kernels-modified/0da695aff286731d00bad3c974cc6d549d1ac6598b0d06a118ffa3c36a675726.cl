//{"a0":0,"a1":1,"a2":2,"b0":3,"b1":4,"b2":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_arg_3_3_kern(global int* a0, global int* a1, global int* a2, global int* b0, global int* b1, global int* b2) {
  unsigned int gtid = get_global_id(0);
  int tmp0 = a0[hook(0, gtid)] + 0;
  int tmp1 = a1[hook(1, gtid)] + 1;
  int tmp2 = a2[hook(2, gtid)] + 2;
  b0[hook(3, gtid)] = (0 + 1) * (+tmp0 + tmp1 + tmp2);
  b1[hook(4, gtid)] = (1 + 1) * (+tmp0 + tmp1 + tmp2);
  b2[hook(5, gtid)] = (2 + 1) * (+tmp0 + tmp1 + tmp2);
}