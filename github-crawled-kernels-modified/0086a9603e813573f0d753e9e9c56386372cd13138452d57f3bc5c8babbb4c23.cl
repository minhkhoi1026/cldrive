//{"a0":0,"a1":1,"a2":2,"a3":3,"a4":4,"a5":5,"a6":6,"a7":7,"b0":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_arg_8_1_kern(global int* a0, global int* a1, global int* a2, global int* a3, global int* a4, global int* a5, global int* a6, global int* a7, global int* b0) {
  unsigned int gtid = get_global_id(0);
  int tmp0 = a0[hook(0, gtid)] + 0;
  int tmp1 = a1[hook(1, gtid)] + 1;
  int tmp2 = a2[hook(2, gtid)] + 2;
  int tmp3 = a3[hook(3, gtid)] + 3;
  int tmp4 = a4[hook(4, gtid)] + 4;
  int tmp5 = a5[hook(5, gtid)] + 5;
  int tmp6 = a6[hook(6, gtid)] + 6;
  int tmp7 = a7[hook(7, gtid)] + 7;
  b0[hook(8, gtid)] = (0 + 1) * (+tmp0 + tmp1 + tmp2 + tmp3 + tmp4 + tmp5 + tmp6 + tmp7);
}