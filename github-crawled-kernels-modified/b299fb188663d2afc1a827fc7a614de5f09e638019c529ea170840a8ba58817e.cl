//{"a0":0,"b0":1,"b1":2,"b2":3,"b3":4,"b4":5,"b5":6,"b6":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_arg_1_7_kern(global float4* a0, global float4* b0, global float4* b1, global float4* b2, global float4* b3, global float4* b4, global float4* b5, global float4* b6) {
  float4 za = (float4)(0.75f, 0.5f, 0.25f, 0.33f);
  unsigned int gtid = get_global_id(0);
  float4 tmp0 = a0[hook(0, gtid)] + 0.1f + za;
  b0[hook(1, gtid)] = (0.0f + 1.1f) * (+tmp0);
  b1[hook(2, gtid)] = (1.0f + 1.1f) * (+tmp0);
  b2[hook(3, gtid)] = (2.0f + 1.1f) * (+tmp0);
  b3[hook(4, gtid)] = (3.0f + 1.1f) * (+tmp0);
  b4[hook(5, gtid)] = (4.0f + 1.1f) * (+tmp0);
  b5[hook(6, gtid)] = (5.0f + 1.1f) * (+tmp0);
  b6[hook(7, gtid)] = (6.0f + 1.1f) * (+tmp0);
}