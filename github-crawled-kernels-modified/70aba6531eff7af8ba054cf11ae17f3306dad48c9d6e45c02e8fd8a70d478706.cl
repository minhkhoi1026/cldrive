//{"a0":0,"a1":1,"a2":2,"b0":3,"b1":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_fa1_3_2_kern(global float* a0, global float* a1, global float* a2, global float* b0, global float* b1) {
  unsigned int gtid = get_global_id(0);
  float tmp0 = a0[hook(0, gtid)] + 0.1f;
  float tmp1 = a1[hook(1, gtid)] + 1.1f;
  float tmp2 = a2[hook(2, gtid)] + 2.1f;
  b0[hook(3, gtid)] = (0.0f + 1.1f) * (+tmp0 + tmp1 + tmp2);
  b1[hook(4, gtid)] = (1.0f + 1.1f) * (+tmp0 + tmp1 + tmp2);
}