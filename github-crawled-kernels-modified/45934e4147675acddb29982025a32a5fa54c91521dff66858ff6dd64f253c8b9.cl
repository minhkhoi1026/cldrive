//{"N":1,"result_add":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_add_withoutDD4(global float* result_add, int N) {
  float4 t1 = (float4)(0.1, 0.2, 0.3, 0.4);
  float4 t2 = (float4)(0.1, 0.2, 0.3, 0.4);
  float4 t3 = (float4)(0.1, 0.2, 0.3, 0.4);
  float4 t4 = (float4)(0.1, 0.2, 0.3, 0.4);
  float4 t5 = (float4)(0.1, 0.2, 0.3, 0.4);
  float4 t6 = (float4)(0.1, 0.2, 0.3, 0.4);
  float4 t7 = (float4)(0.1, 0.2, 0.3, 0.4);
  float4 t8 = (float4)(0.1, 0.2, 0.3, 0.4);
  float4 t9 = (float4)(0.1, 0.2, 0.3, 0.4);
  float4 t10 = (float4)(0.1, 0.2, 0.3, 0.4);
  float4 t11 = (float4)(0.1, 0.2, 0.3, 0.4);
  float4 t12 = (float4)(0.1, 0.2, 0.3, 0.4);
  float4 t13 = (float4)(0.1, 0.2, 0.3, 0.4);
  float4 t14 = (float4)(0.1, 0.2, 0.3, 0.4);
  float4 t15 = (float4)(0.1, 0.2, 0.3, 0.4);
  ;
  float4 s0 = (float4)(0.2, 0.3, 0.4, 0.5);
  float i = 0;
  float p = 10 * N;
  for (i = 0.0; i < p; i = i + 1.0) {
    t1 += s0;
    t2 += s0;
    t3 += s0;
    t4 += s0;
    t5 += s0;
    t6 += s0;
    t7 += s0;
    t8 += s0;
    t9 += s0;
    t10 += s0;
    t11 += s0;
    t12 += s0;
    t13 += s0;
    t14 += s0;
    t15 += s0;
    ;
  }
  *result_add = t1.s0 + t1.s1 + t1.s2 + t1.s3 + t2.s0 + t2.s1 + t2.s2 + t2.s3 + t3.s0 + t3.s1 + t3.s2 + t3.s3 + t4.s0 + t4.s1 + t4.s2 + t4.s3 + t5.s0 + t5.s1 + t5.s2 + t5.s3 + t6.s0 + t6.s1 + t6.s2 + t6.s3 + t7.s0 + t7.s1 + t7.s2 + t7.s3 + t8.s0 + t8.s1 + t8.s2 + t8.s3 + t9.s0 + t9.s1 + t9.s2 + t9.s3 + t10.s0 + t10.s1 + t10.s2 + t10.s3 + t11.s0 + t11.s1 + t11.s2 + t11.s3 + t12.s0 + t12.s1 + t12.s2 + t12.s3 + t13.s0 + t13.s1 + t13.s2 + t13.s3 + t14.s0 + t14.s1 + t14.s2 + t14.s3 + t15.s0 + t15.s1 + t15.s2 + t15.s3;
}