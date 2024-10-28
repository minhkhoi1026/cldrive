//{"N":1,"result_multi":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_multi_withoutDD1(global float* result_multi, int N) {
  float t1 = 0.0;
  float t2 = 0.0;
  float t3 = t1;
  float t4 = t3;
  float t5 = t4;
  float t6 = t5;
  float t7 = t6;
  float t8 = t7;
  float t9 = t8;
  float t10 = t9;
  float t11 = 0.0;
  float t12 = 0.0;
  float t13 = t1;
  float t14 = t3;
  float t15 = t4;
  float t16 = t5;
  float t17 = t6;
  float t18 = t7;
  float t19 = t8;
  float t20 = t9;
  float t21 = 0.0;
  float t22 = 0.0;
  float t23 = t1;
  float t24 = t3;
  float t25 = t4;
  float t26 = t5;
  float t27 = t6;
  float t28 = t7;
  float t29 = t8;
  float t30 = t9;

  float i = 0.0;
  float p = N;

  for (i = 0.0; i < p; i = i + 1.0) {
    t1 = t1 * i;
    t2 = t2 * i;
    t3 = t3 * i;
    t4 = t4 * i;
    t5 = t5 * i;
    t6 = t6 * i;
    t7 = t7 * i;
    t8 = t8 * i;
    t9 = t9 * i;
    t10 = t10 * i;
    t11 = t11 * i;
    t12 = t12 * i;
    t13 = t13 * i;
    t14 = t14 * i;
    t15 = t15 * i;
    t16 = t16 * i;
    t17 = t17 * i;
    t18 = t18 * i;
    t19 = t19 * i;
    t20 = t20 * i;
    t21 = t21 * i;
    t22 = t22 * i;
    t23 = t23 * i;
    t24 = t24 * i;
    t25 = t25 * i;
    t26 = t26 * i;
    t27 = t27 * i;
    t28 = t28 * i;
    t29 = t29 * i;
    t30 = t30 * i;
  }
  *result_multi = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12 + t13 + t14 + t15 + t16 + t17 + t18 + t19 + t20 + t21 + t22 + t23 + t24 + t25 + t26 + t27 + t28 + t29 + t30;
}