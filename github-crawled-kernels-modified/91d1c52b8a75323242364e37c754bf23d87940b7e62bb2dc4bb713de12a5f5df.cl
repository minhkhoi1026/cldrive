//{"a0":0,"a1":1,"a2":2,"b0":3,"b1":4,"b2":5,"b3":6,"b4":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_arg_3_5_kern(global int* a0, global int* a1, global int* a2, global int* b0, global int* b1, global int* b2, global int* b3, global int* b4) {
  unsigned int gtid = get_global_id(0);
  int tmp0 = a0[hook(0, gtid)] + 0;
  int tmp1 = a1[hook(1, gtid)] + 1;
  int tmp2 = a2[hook(2, gtid)] + 2;
  b0[hook(3, gtid)] = (0 + 1) * (+tmp0 + tmp1 + tmp2);
  b1[hook(4, gtid)] = (1 + 1) * (+tmp0 + tmp1 + tmp2);
  b2[hook(5, gtid)] = (2 + 1) * (+tmp0 + tmp1 + tmp2);
  b3[hook(6, gtid)] = (3 + 1) * (+tmp0 + tmp1 + tmp2);
  b4[hook(7, gtid)] = (4 + 1) * (+tmp0 + tmp1 + tmp2);
}