//{"N":1,"result_atanpi":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_atanpi_withoutDD1(global float* result_atanpi, int N) {
  float t1 = 1.2;
  float t2 = 1.1;
  float t3 = 1.1;
  float t4 = 1.1;
  float t5 = 1.1;
  float t6 = 1.1;
  float t7 = 1.1;
  float t8 = 1.1;
  float t9 = 1.1;
  float t10 = 1.1;

  float i = 0.0;
  float n = (float)(N);

  for (i = 0.0; i < n; i = i + 0.1) {
    t1 = atanpi(i);
    t2 = atanpi(i);
    t3 = atanpi(i);
    t4 = atanpi(i);
    t5 = atanpi(i);
    t6 = atanpi(i);
    t7 = atanpi(i);
    t8 = atanpi(i);
    t9 = atanpi(i);
    t10 = atanpi(i);
  }
  *result_atanpi = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}