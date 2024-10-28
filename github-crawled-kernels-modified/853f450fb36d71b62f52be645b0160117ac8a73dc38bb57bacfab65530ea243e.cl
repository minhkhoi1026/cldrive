//{"N":1,"result_mad":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_mad_withoutDD8(global float* result_mad, int N) {
  float s = 1;
  float8 t1 = s + (float8)(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7);
  float8 t2 = s + (float8)(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7);
  float8 t3 = s + (float8)(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7);
  float8 t4 = s + (float8)(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7);
  float8 t5 = s + (float8)(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7);
  float8 t6 = s + (float8)(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7);
  float8 t7 = s + (float8)(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7);
  float8 t8 = s + (float8)(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7);
  float8 t9 = s + (float8)(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7);
  float8 t10 = s + (float8)(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7);
  float8 t11 = s + (float8)(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7);
  float8 t12 = s + (float8)(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7);
  float8 t13 = s + (float8)(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7);
  float8 t14 = s + (float8)(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7);
  float8 t15 = s + (float8)(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7);
  float i = 0.0;
  float pt = 0.98;
  float p = 8 * N;
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
  *result_mad = t1.s0 + t1.s1 + t1.s2 + t1.s3 + t1.s4 + t1.s5 + t1.s6 + t1.s7 + t2.s0 + t2.s1 + t2.s2 + t2.s3 + t2.s4 + t2.s5 + t2.s6 + t2.s7 + t3.s0 + t3.s1 + t3.s2 + t3.s3 + t3.s4 + t3.s5 + t3.s6 + t3.s7 + t4.s0 + t4.s1 + t4.s2 + t4.s3 + t4.s4 + t4.s5 + t4.s6 + t4.s7 + t5.s0 + t5.s1 + t5.s2 + t5.s3 + t5.s4 + t5.s5 + t5.s6 + t5.s7 + t6.s0 + t6.s1 + t6.s2 + t6.s3 + t6.s4 + t6.s5 + t6.s6 + t6.s7 + t7.s0 + t7.s1 + t7.s2 + t7.s3 + t7.s4 + t7.s5 + t7.s6 + t7.s7 + t8.s0 + t8.s1 + t8.s2 + t8.s3 + t8.s4 + t8.s5 + t8.s6 + t8.s7 + t9.s0 + t9.s1 + t9.s2 + t9.s3 + t9.s4 + t9.s5 + t9.s6 + t9.s7 + t10.s0 + t10.s1 + t10.s2 + t10.s3 + t10.s4 + t10.s5 + t10.s6 + t10.s7 + t11.s0 + t11.s1 + t11.s2 + t11.s3 + t11.s4 + t11.s5 + t11.s6 + t11.s7 + t12.s0 + t12.s1 + t12.s2 + t12.s3 + t12.s4 + t12.s5 + t12.s6 + t12.s7 + t13.s0 + t13.s1 + t13.s2 + t13.s3 + t13.s4 + t13.s5 + t13.s6 + t13.s7 + t14.s0 + t14.s1 + t14.s2 + t14.s3 + t13.s4 + t13.s5 + t13.s6 + t13.s7 + t15.s0 + t15.s1 + t15.s2 + t15.s3 + t15.s4 + t15.s5 + t15.s6 + t15.s7;
}