//{"N":1,"result_asinpi":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_asinpi_withoutDD1(global float* result_asinpi, int N) {
  float t1 = -2.3;
  float t2 = -2.3;
  float t3 = -2.3;
  float t4 = -2.3;
  float t5 = -2.3;
  float t6 = -2.3;
  float t7 = -2.3;
  float t8 = -2.3;
  float t9 = -2.3;
  float t10 = -2.3;

  float i = 0.0;

  for (i = 0.0; i <= 1.0; i = i + 0.01) {
    t1 += asinpi(i);
    t2 += asinpi(i);
    t3 += asinpi(i);
    t4 += asinpi(i);
    t5 += asinpi(i);
    t6 += asinpi(i);
    t7 += asinpi(i);
    t8 += asinpi(i);
    t9 += asinpi(i);
    t10 += asinpi(i);
  }
  *result_asinpi = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}