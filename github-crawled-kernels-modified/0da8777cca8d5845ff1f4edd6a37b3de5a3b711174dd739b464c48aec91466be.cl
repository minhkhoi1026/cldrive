//{"N":1,"result_sincos":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_sincos_withoutDD1(global float* result_sincos, int N) {
  float t1;
  float t2;
  float t3;
  float t4;
  float t5;
  float t6;
  float t7;
  float t8;
  float t9;
  float t10;

  float i = 1.0;
  float j;
  float n = 10.0 * (float)(N);
  for (i = 1.0; i < n; i = i + 1) {
    t1 = sincos(i, &j);
    t2 = sincos(i + 0.1, &j);
    t3 = sincos(i + 0.2, &j);
    t4 = sincos(i + 0.3, &j);
    t5 = sincos(i + 0.4, &j);
    t6 = sincos(i + 0.5, &j);
    t7 = sincos(i + 0.6, &j);
    t8 = sincos(i + 0.7, &j);
    t9 = sincos(i + 0.8, &j);
    t10 = sincos(i + 0.9, &j);
  }
  *result_sincos = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}