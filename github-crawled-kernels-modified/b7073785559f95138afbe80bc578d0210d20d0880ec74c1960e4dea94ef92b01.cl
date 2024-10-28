//{"N":1,"result_fmax":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_fmax_withoutDD8(global float* result_fmax, int N) {
  float8 t1 = -1 + (float8)(0);
  float8 t2 = -1 + (float8)(0);
  float8 t3 = t1;
  float8 t4 = t3;
  float8 t5 = t4;
  float8 t6 = t5;
  float8 t7 = t6;
  float8 t8 = t7;
  float8 t9 = t8;
  float8 t10 = t9;
  float8 t11 = -1 + (float8)(0);
  float8 t12 = -1 + (float8)(0);
  float8 t13 = t1;
  float8 t14 = t3;
  float8 t15 = t4;
  float8 t16 = t5;
  float8 t17 = t6;
  float8 t18 = t7;
  float8 t19 = t8;
  float8 t20 = t9;
  float8 t21 = -1;
  float8 t22 = -1;
  float8 t23 = t1;
  float8 t24 = t3;
  float8 t25 = t4;
  float8 t26 = t5;
  float8 t27 = t6;
  float8 t28 = t7;
  float8 t29 = t8;
  float8 t30 = t9;

  float8 i = 0 + (float8)(0);

  int j = 0;
  for (j = 0; j < N; j++) {
    t1 += fmax(t1, i);
    t2 += fmax(t2, i);
    t3 += fmax(t3, i);
    t4 += fmax(t4, i);
    t5 += fmax(t5, i);
    t6 += fmax(t6, i);
    t7 += fmax(t7, i);
    t8 += fmax(t8, i);
    t9 += fmax(t9, i);
    t10 += fmax(t10, i);
    t11 += fmax(t11, i);
    t12 += fmax(t12, i);
    t13 += fmax(t13, i);
    t14 += fmax(t14, i);
    t15 += fmax(t15, i);
    t16 += fmax(t16, i);
    t17 += fmax(t17, i);
    t18 += fmax(t18, i);
    t19 += fmax(t19, i);
    t20 += fmax(t20, i);
    t21 += fmax(t21, i);
    t22 += fmax(t22, i);
    t22 += fmax(t23, i);
    t24 += fmax(t24, i);
    t25 += fmax(t25, i);
    t26 += fmax(t26, i);
    t27 += fmax(t27, i);
    t28 += fmax(t28, i);
    t29 += fmax(t29, i);
    t30 += fmax(t30, i);
  }
  *result_fmax = t1.s0 + t1.s1 + t1.s2 + t1.s3 + t1.s4 + t1.s5 + t1.s6 + t1.s7 + t2.s0 + t2.s1 + t2.s2 + t2.s3 + t2.s4 + t2.s5 + t2.s6 + t2.s7 + t3.s0 + t3.s1 + t3.s2 + t3.s3 + t3.s4 + t3.s5 + t3.s6 + t3.s7 + t4.s0 + t4.s1 + t4.s2 + t4.s3 + t4.s4 + t4.s5 + t4.s6 + t4.s7 + t5.s0 + t5.s1 + t5.s2 + t5.s3 + t5.s4 + t5.s5 + t5.s6 + t5.s7 + t6.s0 + t6.s1 + t6.s2 + t6.s3 + t6.s4 + t6.s5 + t6.s6 + t6.s7 + t7.s0 + t7.s1 + t7.s2 + t7.s3 + t7.s4 + t7.s5 + t7.s6 + t7.s7 + t8.s0 + t8.s1 + t8.s2 + t8.s3 + t8.s4 + t8.s5 + t8.s6 + t8.s7 + t9.s0 + t9.s1 + t9.s2 + t9.s3 + t9.s4 + t9.s5 + t9.s6 + t9.s7 + t10.s0 + t10.s1 + t10.s2 + t10.s3 + t10.s4 + t10.s5 + t10.s6 + t10.s7 + t11.s0 + t11.s1 + t11.s2 + t11.s3 + t11.s4 + t11.s5 + t11.s6 + t11.s7 + t12.s0 + t12.s1 + t12.s2 + t12.s3 + t12.s4 + t12.s5 + t12.s6 + t12.s7 + t13.s0 + t13.s1 + t13.s2 + t13.s3 + t13.s4 + t13.s5 + t13.s6 + t13.s7 + t14.s0 + t14.s1 + t14.s2 + t14.s3 + t14.s4 + t14.s5 + t14.s6 + t14.s7 + t15.s0 + t15.s1 + t15.s2 + t15.s3 + t15.s4 + t15.s5 + t15.s6 + t15.s7 + t16.s0 + t16.s1 + t16.s2 + t16.s3 + t16.s4 + t16.s5 + t16.s6 + t16.s7 + t17.s0 + t17.s1 + t17.s2 + t17.s3 + t17.s4 + t17.s5 + t17.s6 + t17.s7 + t18.s0 + t18.s1 + t18.s2 + t18.s3 + t18.s4 + t18.s5 + t18.s6 + t18.s7 + t19.s0 + t19.s1 + t19.s2 + t19.s3 + t19.s4 + t19.s5 + t19.s6 + t19.s7 + t20.s0 + t20.s1 + t20.s2 + t20.s3 + t20.s4 + t20.s5 + t20.s6 + t20.s7 + t21.s0 + t21.s1 + t21.s2 + t21.s3 + t21.s4 + t21.s5 + t21.s6 + t21.s7 + t22.s0 + t22.s1 + t22.s2 + t22.s3 + t22.s4 + t22.s5 + t22.s6 + t22.s7 + t23.s0 + t23.s1 + t23.s2 + t23.s3 + t23.s4 + t23.s5 + t23.s6 + t23.s7 + t24.s0 + t24.s1 + t24.s2 + t24.s3 + t24.s4 + t24.s5 + t24.s6 + t24.s7 + t25.s0 + t25.s1 + t25.s2 + t25.s3 + t25.s4 + t25.s5 + t25.s6 + t25.s7 + t26.s0 + t26.s1 + t26.s2 + t26.s3 + t26.s4 + t26.s5 + t26.s6 + t26.s7 + t27.s0 + t27.s1 + t27.s2 + t27.s3 + t27.s4 + t27.s5 + t27.s6 + t27.s7 + t28.s0 + t28.s1 + t28.s2 + t28.s3 + t28.s4 + t28.s5 + t28.s6 + t28.s7 + t29.s0 + t29.s1 + t29.s2 + t29.s3 + t29.s4 + t29.s5 + t29.s6 + t29.s7 + t30.s0 + t30.s1 + t30.s2 + t30.s3 + t30.s4 + t30.s5 + t30.s6 + t30.s7;
}