//{"N":1,"result_sub":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_sub_withoutDD1(global float* result_sub, int N) {
  float t1 = 9999.0;
  float t2 = 9999.0;
  float t3 = t1;
  float t4 = t3;
  float t5 = t4;
  float t6 = t5;
  float t7 = t6;
  float t8 = t7;
  float t9 = t8;
  float t10 = t9;
  float t11 = t3;
  float t12 = t3;
  float t13 = t1;
  float t14 = t3;
  float t15 = t4;
  float t16 = t5;
  float t17 = t6;
  float t18 = t7;
  float t19 = t8;
  float t20 = t9;
  float t21 = t3;
  float t22 = t3;
  float t23 = t1;
  float t24 = t3;
  float t25 = t4;
  float t26 = t5;
  float t27 = t6;
  float t28 = t7;
  float t29 = t8;
  float t30 = t9;
  float i = 0.0;
  for (i = 0.0; i < 50 * N; i += 1.0) {
    t1 -= i;
    t2 -= i;
    t3 -= i;
    t4 -= i;
    t5 -= i;
    t6 -= i;
    t7 -= i;
    t8 -= i;
    t9 -= i;
    t10 -= i;
    t11 -= i;
    t12 -= i;
    t13 -= i;
    t14 -= i;
    t15 -= i;
    t16 -= i;
    t17 -= i;
    t18 -= i;
    t19 -= i;
    t20 -= i;
    t21 -= i;
    t22 -= i;
    t23 -= i;
    t24 -= i;
    t25 -= i;
    t26 -= i;
    t27 -= i;
    t28 -= i;
    t29 -= i;
    t30 -= i;
  }

  *result_sub = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12 + t13 + t14 + t15 + t16 + t17 + t18 + t19 + t20 + t21 + t22 + t23 + t24 + t25 + t26 + t27 + t28 + t29 + t30;
}