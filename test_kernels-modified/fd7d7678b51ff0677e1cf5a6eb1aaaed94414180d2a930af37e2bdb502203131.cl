//{"a0":0,"a1":1,"a2":2,"a3":3,"b0":4,"b1":5,"b2":6,"b3":7,"b4":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_arg_4_5_kern(global float4* a0, global float4* a1, global float4* a2, global float4* a3, global float4* b0, global float4* b1, global float4* b2, global float4* b3, global float4* b4) {
  float4 za = (float4)(0.75f, 0.5f, 0.25f, 0.33f);
  unsigned int gtid = get_global_id(0);
  float4 tmp0 = a0[hook(0, gtid)] + 0.1f + za;
  float4 tmp1 = a1[hook(1, gtid)] + 1.1f + za;
  float4 tmp2 = a2[hook(2, gtid)] + 2.1f + za;
  float4 tmp3 = a3[hook(3, gtid)] + 3.1f + za;
  b0[hook(4, gtid)] = (0.0f + 1.1f) * (+tmp0 + tmp1 + tmp2 + tmp3);
  b1[hook(5, gtid)] = (1.0f + 1.1f) * (+tmp0 + tmp1 + tmp2 + tmp3);
  b2[hook(6, gtid)] = (2.0f + 1.1f) * (+tmp0 + tmp1 + tmp2 + tmp3);
  b3[hook(7, gtid)] = (3.0f + 1.1f) * (+tmp0 + tmp1 + tmp2 + tmp3);
  b4[hook(8, gtid)] = (4.0f + 1.1f) * (+tmp0 + tmp1 + tmp2 + tmp3);
}