//{"a0":0,"b0":1,"b1":2,"b2":3,"b3":4,"b4":5,"b5":6,"b6":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_arg_1_7_kern(global int4* a0, global int4* b0, global int4* b1, global int4* b2, global int4* b3, global int4* b4, global int4* b5, global int4* b6) {
  int4 za = (int4)(0, 1, 2, 3);
  unsigned int gtid = get_global_id(0);
  int4 tmp0 = a0[hook(0, gtid)] + 0 + za;
  b0[hook(1, gtid)] = (0 + 1) * (+tmp0);
  b1[hook(2, gtid)] = (1 + 1) * (+tmp0);
  b2[hook(3, gtid)] = (2 + 1) * (+tmp0);
  b3[hook(4, gtid)] = (3 + 1) * (+tmp0);
  b4[hook(5, gtid)] = (4 + 1) * (+tmp0);
  b5[hook(6, gtid)] = (5 + 1) * (+tmp0);
  b6[hook(7, gtid)] = (6 + 1) * (+tmp0);
}