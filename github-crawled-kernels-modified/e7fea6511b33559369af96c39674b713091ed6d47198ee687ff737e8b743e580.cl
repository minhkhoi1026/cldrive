//{"N":1,"result_acos":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_acos_withoutDD1(global float* result_acos, int N) {
  float t1 = 1.23;
  float t2 = t1;
  float t3 = t1;
  float t4 = t1;
  float t5 = t1;
  float t6 = t1;
  float t7 = t1;
  float t8 = t1;
  float t9 = t1;
  float t10 = t1;
  float t11 = 1.23;
  float t12 = t1;
  float t13 = t1;
  float t14 = t1;
  float t15 = t1;
  float t16 = t1;
  float t17 = t1;
  float t18 = t1;
  float t19 = t1;
  float t20 = t1;
  float t21 = 1.23;
  float t22 = t1;
  float t23 = t1;
  float t24 = t1;
  float t25 = t1;
  float t26 = t1;
  float t27 = t1;
  float t28 = t1;
  float t29 = t1;
  float t30 = t1;

  float j = 0.0;
  for (j = 0.0; j < 1.0; j += 0.001) {
    t1 = acos(j);
    t2 = acos(j);
    t3 = acos(j);
    t4 = acos(j);
    t5 = acos(j);
    t6 = acos(j);
    t7 = acos(j);
    t8 = acos(j);
    t9 = acos(j);
    t10 = acos(j);
    t11 = acos(j);
    t12 = acos(j);
    t13 = acos(j);
    t14 = acos(j);
    t15 = acos(j);
    t16 = acos(j);
    t17 = acos(j);
    t18 = acos(j);
    t19 = acos(j);
    t20 = acos(j);
    t21 = acos(j);
    t22 = acos(j);
    t23 = acos(j);
    t24 = acos(j);
    t25 = acos(j);
    t26 = acos(j);
    t27 = acos(j);
    t28 = acos(j);
    t29 = acos(j);
    t30 = acos(j);
  }
  *result_acos = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12 + t13 + t14 + t15 + t16 + t17 + t18 + t19 + t20 + t21 + t22 + t23 + t24 + t25 + t26 + t27 + t28 + t29 + t30;
}