//{"a0":0,"b0":1,"b1":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_arg_1_2_kern(global int4* a0, global int4* b0, global int4* b1) {
  int4 za = (int4)(0, 1, 2, 3);
  unsigned int gtid = get_global_id(0);
  int4 tmp0 = a0[hook(0, gtid)] + 0 + za;
  b0[hook(1, gtid)] = (0 + 1) * (+tmp0);
  b1[hook(2, gtid)] = (1 + 1) * (+tmp0);
}