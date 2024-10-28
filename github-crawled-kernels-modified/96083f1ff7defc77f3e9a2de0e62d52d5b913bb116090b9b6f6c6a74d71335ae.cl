//{"N":1,"result_acospi":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_acospi_withoutDD1(global float* result_acospi, int N) {
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

  float i = -1.0;
  for (i = -1.0; i <= 1.0; i = i + 0.0001) {
    t1 = acospi(i);
    t2 = acospi(i);
    t3 = acospi(i);
    t4 = acospi(i);
    t5 = acospi(i);
    t6 = acospi(i);
    t7 = acospi(i);
    t8 = acospi(i);
    t9 = acospi(i);
    t10 = acospi(i);
  }
  *result_acospi = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}