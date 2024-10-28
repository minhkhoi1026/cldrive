//{"a0":0,"a1":1,"b0":2,"b1":3,"b2":4,"b3":5,"b4":6,"b5":7,"b6":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_arg_2_7_kern(global float* a0, global float* a1, global float* b0, global float* b1, global float* b2, global float* b3, global float* b4, global float* b5, global float* b6) {
  unsigned int gtid = get_global_id(0);
  float tmp0 = a0[hook(0, gtid)] + 0.1f;
  float tmp1 = a1[hook(1, gtid)] + 1.1f;
  b0[hook(2, gtid)] = (0.0f + 1.1f) * (+tmp0 + tmp1);
  b1[hook(3, gtid)] = (1.0f + 1.1f) * (+tmp0 + tmp1);
  b2[hook(4, gtid)] = (2.0f + 1.1f) * (+tmp0 + tmp1);
  b3[hook(5, gtid)] = (3.0f + 1.1f) * (+tmp0 + tmp1);
  b4[hook(6, gtid)] = (4.0f + 1.1f) * (+tmp0 + tmp1);
  b5[hook(7, gtid)] = (5.0f + 1.1f) * (+tmp0 + tmp1);
  b6[hook(8, gtid)] = (6.0f + 1.1f) * (+tmp0 + tmp1);
}