//{"a0":0,"b0":1,"b1":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_arg_1_2_kern(global float4* a0, global float4* b0, global float4* b1) {
  float4 za = (float4)(0.75f, 0.5f, 0.25f, 0.33f);
  unsigned int gtid = get_global_id(0);
  float4 tmp0 = a0[hook(0, gtid)] + 0.1f + za;
  b0[hook(1, gtid)] = (0.0f + 1.1f) * (+tmp0);
  b1[hook(2, gtid)] = (1.0f + 1.1f) * (+tmp0);
}