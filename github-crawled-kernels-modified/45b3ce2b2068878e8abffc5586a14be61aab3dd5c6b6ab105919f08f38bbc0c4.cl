//{"N":1,"result_expm1":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_expm1_withoutDD1(global float* result_expm1, int N) {
  float t1 = 1.2;
  float t2 = 1.2;
  float t3 = 1.2;
  float t4 = 1.2;
  float t5 = 1.2;
  float t6 = 1.2;
  float t7 = 1.2;
  float t8 = 1.2;
  float t9 = 1.2;
  float t10 = 1.2;

  float i = 1.0;
  float n = 0.07 * (float)(N);
  for (i = 1.0; i < n; i = i + 0.01) {
    t1 = expm1(i + 0.1);
    t2 = expm1(i + 0.2);
    t3 = expm1(i + 0.3);
    t4 = expm1(i + 0.4);
    t5 = expm1(i + 0.5);
    t6 = expm1(i + 0.6);
    t7 += expm1(i + 0.6);
    t8 += expm1(i + 0.7);
    t9 += expm1(i + 0.8);
    t10 += expm1(i + 0.9);
  }
  *result_expm1 = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}