//{"a0":0,"a1":1,"b0":2,"b1":3,"b2":4,"b3":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_arg_2_4_kern(global int* a0, global int* a1, global int* b0, global int* b1, global int* b2, global int* b3) {
  unsigned int gtid = get_global_id(0);
  int tmp0 = a0[hook(0, gtid)] + 0;
  int tmp1 = a1[hook(1, gtid)] + 1;
  b0[hook(2, gtid)] = (0 + 1) * (+tmp0 + tmp1);
  b1[hook(3, gtid)] = (1 + 1) * (+tmp0 + tmp1);
  b2[hook(4, gtid)] = (2 + 1) * (+tmp0 + tmp1);
  b3[hook(5, gtid)] = (3 + 1) * (+tmp0 + tmp1);
}