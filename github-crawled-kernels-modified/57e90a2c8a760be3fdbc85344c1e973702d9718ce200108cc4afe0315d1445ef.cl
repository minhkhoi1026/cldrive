//{"N":1,"result_fract":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_fract_withoutDD1(global float* result_fract, int N) {
  float t1 = 1.0;
  float t2 = 1.0;
  float t3 = 1.0;
  float t4 = 1.0;
  float t5 = 1.0;
  float t6 = 1.0;
  float t7 = 1.0;
  float t8 = 1.0;
  float t9 = 1.0;
  float t10 = 1.0;

  float i = 0.0;
  float j;
  float n = 10 * N;

  for (i = 0.0; i < n; i = i + 1.0) {
    t1 = fract(i, &j);
    t2 = fract(i + 0.1, &j);
    t3 = fract(i + 0.2, &j);
    t4 = fract(i + 0.3, &j);
    t5 = fract(i + 0.4, &j);
    t6 = fract(i + 0.5, &j);
    t7 = fract(i + 0.6, &j);
    t8 = fract(i + 0.7, &j);
    t9 = fract(i + 0.8, &j);
    t10 = fract(i + 0.9, &j);
  }
  *result_fract = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}