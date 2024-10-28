//{"N":1,"result_sinpi":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_sinpi_withoutDD1(global float* result_sinpi, int N) {
  float t1 = 1.3;
  float t2 = 2.0;
  float t3 = 4.3;
  float t4 = 4.3;
  float t5 = 4.3;
  float t6 = 4.3;
  float t7 = 4.3;
  float t8 = 4.3;
  float t9 = 4.3;
  float t10 = 4.3;

  float i = 1.0;
  float n = 10 * N;
  for (i = 1.0; i < n; i = i + 1.0) {
    t1 += sinpi(i);
    t2 += sinpi(i + 0.01);
    t3 += sinpi(i + 0.03);
    t4 += sinpi(i + 0.02);
    t5 += sinpi(i + 0.04);
    t6 += sinpi(i + 0.05);
    t7 += sinpi(i + 0.06);
    t8 += sinpi(i + 0.07);
    t9 += sinpi(i + 0.08);
    t10 += sinpi(i + 0.09);
  }
  *result_sinpi = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}