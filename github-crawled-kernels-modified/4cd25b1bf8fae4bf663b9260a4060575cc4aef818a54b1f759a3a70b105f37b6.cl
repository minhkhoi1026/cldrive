//{"N":1,"result_mad":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_mad_withoutDD2(global float* result_mad, int N) {
  float s = 1;
  float2 t1 = s + (float2)(0.2, 0.3);
  float2 t2 = s + (float2)(0.2, 0.3);
  float2 t3 = s + (float2)(0.2, 0.3);
  float2 t4 = s + (float2)(0.2, 0.3);
  float2 t5 = s + (float2)(0.2, 0.3);
  float2 t6 = s + (float2)(0.2, 0.3);
  float2 t7 = s + (float2)(0.2, 0.3);
  float2 t8 = s + (float2)(0.2, 0.3);
  float2 t9 = s + (float2)(0.2, 0.3);
  float2 t10 = s + (float2)(0.2, 0.3);
  float2 t11 = s + (float2)(0.2, 0.3);
  float2 t12 = s + (float2)(0.2, 0.3);
  float2 t13 = s + (float2)(0.2, 0.3);
  float2 t14 = s + (float2)(0.2, 0.3);
  float2 t15 = s + (float2)(0.2, 0.3);
  float i = 0.0;
  float pt = 0.98;
  float p = 512 * N;
  for (i = 0.0; i < p; i = i + 1.0) {
    t1 = mad(t1, pt, 0.5);
    t2 = mad(t2, pt, 0.5);
    t3 = mad(t3, pt, 0.5);
    t4 = mad(t4, pt, 0.5);
    t5 = mad(t5, pt, 0.5);
    t6 = mad(t6, pt, 0.5);
    t7 = mad(t7, pt, 0.5);
    t8 = mad(t8, pt, 0.5);
    t9 = mad(t9, pt, 0.5);
    t10 = mad(t10, pt, 0.5);
    t11 = mad(t11, pt, 0.5);
    t12 = mad(t12, pt, 0.5);
    t13 = mad(t13, pt, 0.5);
    t14 = mad(t14, pt, 0.5);
    t15 = mad(t15, pt, 0.5);
  }
  *result_mad = t1.s0 + t1.s1 + t2.s0 + t2.s1 + t3.s0 + t3.s1 + t4.s0 + t4.s1 + t5.s0 + t5.s1 + t6.s0 + t6.s1 + t7.s0 + t7.s1 + t8.s0 + t8.s1 + t9.s0 + t9.s1 + t10.s0 + t10.s1 + t11.s0 + t11.s1 + t12.s0 + t12.s1 + t13.s0 + t13.s1 + t14.s0 + t14.s1 + t15.s0 + t15.s1;
}