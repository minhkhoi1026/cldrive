//{"a0":0,"a1":1,"a2":2,"a3":3,"b0":4,"b1":5,"b2":6,"b3":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_arg_4_4_kern(global int* a0, global int* a1, global int* a2, global int* a3, global int* b0, global int* b1, global int* b2, global int* b3) {
  unsigned int gtid = get_global_id(0);
  int tmp0 = a0[hook(0, gtid)] + 0;
  int tmp1 = a1[hook(1, gtid)] + 1;
  int tmp2 = a2[hook(2, gtid)] + 2;
  int tmp3 = a3[hook(3, gtid)] + 3;
  b0[hook(4, gtid)] = (0 + 1) * (+tmp0 + tmp1 + tmp2 + tmp3);
  b1[hook(5, gtid)] = (1 + 1) * (+tmp0 + tmp1 + tmp2 + tmp3);
  b2[hook(6, gtid)] = (2 + 1) * (+tmp0 + tmp1 + tmp2 + tmp3);
  b3[hook(7, gtid)] = (3 + 1) * (+tmp0 + tmp1 + tmp2 + tmp3);
}