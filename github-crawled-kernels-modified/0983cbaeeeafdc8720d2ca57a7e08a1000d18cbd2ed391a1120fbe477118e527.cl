//{"a0":0,"a1":1,"a2":2,"b0":3,"b1":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_arg_3_2_kern(global float4* a0, global float4* a1, global float4* a2, global float4* b0, global float4* b1) {
  float4 za = (float4)(0.75f, 0.5f, 0.25f, 0.33f);
  unsigned int gtid = get_global_id(0);
  float4 tmp0 = a0[hook(0, gtid)] + 0.1f + za;
  float4 tmp1 = a1[hook(1, gtid)] + 1.1f + za;
  float4 tmp2 = a2[hook(2, gtid)] + 2.1f + za;
  b0[hook(3, gtid)] = (0.0f + 1.1f) * (+tmp0 + tmp1 + tmp2);
  b1[hook(4, gtid)] = (1.0f + 1.1f) * (+tmp0 + tmp1 + tmp2);
}