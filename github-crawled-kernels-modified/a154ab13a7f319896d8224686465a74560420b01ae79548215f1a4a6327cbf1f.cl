//{"N":1,"result_add":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_add_withoutDD2(global float* result_add, int N) {
  float2 t1 = (float2)(0.1, 0.2);
  float2 t2 = (float2)(0.1, 0.2);
  float2 t3 = (float2)(0.1, 0.2);
  float2 t4 = (float2)(0.1, 0.2);
  float2 t5 = (float2)(0.1, 0.2);
  float2 t6 = (float2)(0.1, 0.2);
  float2 t7 = (float2)(0.1, 0.2);
  float2 t8 = (float2)(0.1, 0.2);
  float2 t9 = (float2)(0.1, 0.2);
  float2 t10 = (float2)(0.1, 0.2);
  float2 t11 = (float2)(0.1, 0.2);
  float2 t12 = (float2)(0.1, 0.2);
  float2 t13 = (float2)(0.1, 0.2);
  float2 t14 = (float2)(0.1, 0.2);
  float2 t15 = (float2)(0.1, 0.2);
  ;
  float2 s0 = (float2)(0.2, 0.3);
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
  *result_add = t1.s0 + t1.s1 + t2.s0 + t2.s1 + t3.s0 + t3.s1 + t4.s0 + t4.s1 + t5.s0 + t5.s1 + t6.s0 + t6.s1 + t7.s0 + t7.s1 + t8.s0 + t8.s1 + t9.s0 + t9.s1 + t10.s0 + t10.s1 + t11.s0 + t11.s1 + t12.s0 + t12.s1 + t13.s0 + t13.s1 + t14.s0 + t14.s1 + t15.s0 + t15.s1;
}