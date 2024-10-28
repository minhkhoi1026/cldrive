//{"a0":0,"a1":1,"a2":2,"b0":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_arg_3_1_kern(global int4* a0, global int4* a1, global int4* a2, global int4* b0) {
  int4 za = (int4)(0, 1, 2, 3);
  unsigned int gtid = get_global_id(0);
  int4 tmp0 = a0[hook(0, gtid)] + 0 + za;
  int4 tmp1 = a1[hook(1, gtid)] + 1 + za;
  int4 tmp2 = a2[hook(2, gtid)] + 2 + za;
  b0[hook(3, gtid)] = (0 + 1) * (+tmp0 + tmp1 + tmp2);
}