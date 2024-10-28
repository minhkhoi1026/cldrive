//{"N":1,"result_modf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_modf_withoutDD1(global float* result_modf, int N) {
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

  float i = 0.0;
  float j;
  float n = 0.3 * (float)(N);

  for (i = 0.0; i < n; i = i + 0.01) {
    t1 = modf(i, &j);
    t2 = modf(i, &j);
    t3 = modf(i, &j);
    t4 = modf(i, &j);
    t5 = modf(i, &j);
    t6 = modf(i, &j);
    t7 = modf(i, &j);
    t8 = modf(i, &j);
    t9 = modf(i, &j);
    t10 = modf(i, &j);
  }
  *result_modf = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}