//{"a0":0,"a1":1,"a2":2,"a3":3,"a4":4,"b0":5,"b1":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_arg_5_2_kern(global int* a0, global int* a1, global int* a2, global int* a3, global int* a4, global int* b0, global int* b1) {
  unsigned int gtid = get_global_id(0);
  int tmp0 = a0[hook(0, gtid)] + 0;
  int tmp1 = a1[hook(1, gtid)] + 1;
  int tmp2 = a2[hook(2, gtid)] + 2;
  int tmp3 = a3[hook(3, gtid)] + 3;
  int tmp4 = a4[hook(4, gtid)] + 4;
  b0[hook(5, gtid)] = (0 + 1) * (+tmp0 + tmp1 + tmp2 + tmp3 + tmp4);
  b1[hook(6, gtid)] = (1 + 1) * (+tmp0 + tmp1 + tmp2 + tmp3 + tmp4);
}