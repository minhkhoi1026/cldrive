//{"N":1,"result_fmin":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_fmin_withoutDD1(global float* result_fmin, int N) {
  float t1 = 0.234;
  float t2 = 0.235;
  float t3 = t1;
  float t4 = t3;
  float t5 = t4;
  float t6 = t5;
  float t7 = t6;
  float t8 = t7;
  float t9 = t8;
  float t10 = t9;
  float t11 = 0.234;
  float t12 = 0.235;
  float t13 = t1;
  float t14 = t3;
  float t15 = t4;
  float t16 = t5;
  float t17 = t6;
  float t18 = t7;
  float t19 = t8;
  float t20 = t9;
  float t21 = 0.234;
  float t22 = 0.235;
  float t23 = t1;
  float t24 = t3;
  float t25 = t4;
  float t26 = t5;
  float t27 = t6;
  float t28 = t7;
  float t29 = t8;
  float t30 = t9;

  float i = 0.01;

  int j = 0;
  for (j = 0; j <= 100 * N; j++) {
    t1 += fmin(t1, i);
    t2 += fmin(t2, i);
    t3 += fmin(t3, i);
    t4 += fmin(t4, i);
    t5 += fmin(t5, i);
    t6 += fmin(t6, i);
    t7 += fmin(t7, i);
    t8 += fmin(t8, i);
    t9 += fmin(t9, i);
    t10 += fmin(t10, i);
    t11 += fmin(t11, i);
    t12 += fmin(t12, i);
    t13 += fmin(t13, i);
    t14 += fmin(t14, i);
    t15 += fmin(t15, i);
    t16 += fmin(t16, i);
    t17 += fmin(t17, i);
    t18 += fmin(t18, i);
    t19 += fmin(t19, i);
    t20 += fmin(t20, i);
    t21 += fmin(t21, i);
    t22 += fmin(t22, i);
    t23 += fmin(t23, i);
    t24 += fmin(t24, i);
    t25 += fmin(t25, i);
    t26 += fmin(t26, i);
    t27 += fmin(t27, i);
    t28 += fmin(t28, i);
    t29 += fmin(t29, i);
    t30 += fmin(t30, i);
  }
  *result_fmin = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12 + t13 + t14 + t15 + t16 + t17 + t18 + t19 + t20 + t21 + t22 + t23 + t24 + t25 + t26 + t27 + t28 + t29 + t30;
}