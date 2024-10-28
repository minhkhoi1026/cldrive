//{"N":1,"result_fmax":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_fmax_withoutDD1(global float* result_fmax, int N) {
  float t1 = -1;
  float t2 = -1;
  float t3 = t1;
  float t4 = t3;
  float t5 = t4;
  float t6 = t5;
  float t7 = t6;
  float t8 = t7;
  float t9 = t8;
  float t10 = t9;
  float t11 = -1;
  float t12 = -1;
  float t13 = t1;
  float t14 = t3;
  float t15 = t4;
  float t16 = t5;
  float t17 = t6;
  float t18 = t7;
  float t19 = t8;
  float t20 = t9;
  float t21 = -1;
  float t22 = -1;
  float t23 = t1;
  float t24 = t3;
  float t25 = t4;
  float t26 = t5;
  float t27 = t6;
  float t28 = t7;
  float t29 = t8;
  float t30 = t9;

  float i = 0;

  int j = 0;
  for (j = 0; j < 100 * N; j++) {
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
  *result_fmax = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12 + t13 + t14 + t15 + t16 + t17 + t18 + t19 + t20 + t21 + t22 + t23 + t24 + t25 + t26 + t27 + t28 + t29 + t30;
}