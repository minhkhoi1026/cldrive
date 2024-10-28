//{"N":1,"result_rsqrt":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_rsqrt_withoutDD1(global float* result_rsqrt, int N) {
  float t1 = 1.1;
  float t2 = 1.1;
  float t3 = t1;
  float t4 = t3;
  float t5 = t4;
  float t6 = t5;
  float t7 = t6;
  float t8 = t7;
  float t9 = t8;
  float t10 = t9;

  float i = 0.01;

  for (i = 0.01; i <= 25.6 * N; i = i + 0.01) {
    t1 = rsqrt(i);
    t2 = rsqrt(i + 0.01);
    t3 = rsqrt(i + 0.02);
    t4 = rsqrt(i + 0.03);
    t5 = rsqrt(i + 0.04);
    t6 = rsqrt(i + 0.05);
    t7 = rsqrt(i + 0.06);
    t8 = rsqrt(i + 0.07);
    t9 = rsqrt(i + 0.08);
    t10 = rsqrt(i + 0.09);
  }
  *result_rsqrt = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}