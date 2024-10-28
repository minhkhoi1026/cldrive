//{"a0":0,"a1":1,"a2":2,"a3":3,"a4":4,"b0":5,"b1":6,"b2":7,"b3":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_arg_5_4_kern(global float* a0, global float* a1, global float* a2, global float* a3, global float* a4, global float* b0, global float* b1, global float* b2, global float* b3) {
  unsigned int gtid = get_global_id(0);
  float tmp0 = a0[hook(0, gtid)] + 0.1f;
  float tmp1 = a1[hook(1, gtid)] + 1.1f;
  float tmp2 = a2[hook(2, gtid)] + 2.1f;
  float tmp3 = a3[hook(3, gtid)] + 3.1f;
  float tmp4 = a4[hook(4, gtid)] + 4.1f;
  b0[hook(5, gtid)] = (0.0f + 1.1f) * (+tmp0 + tmp1 + tmp2 + tmp3 + tmp4);
  b1[hook(6, gtid)] = (1.0f + 1.1f) * (+tmp0 + tmp1 + tmp2 + tmp3 + tmp4);
  b2[hook(7, gtid)] = (2.0f + 1.1f) * (+tmp0 + tmp1 + tmp2 + tmp3 + tmp4);
  b3[hook(8, gtid)] = (3.0f + 1.1f) * (+tmp0 + tmp1 + tmp2 + tmp3 + tmp4);
}