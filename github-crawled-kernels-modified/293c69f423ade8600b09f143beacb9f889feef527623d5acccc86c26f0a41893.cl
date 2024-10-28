//{"N":1,"result_hypot":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_hypot_withoutDD1(global float* result_hypot, int N) {
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
  float j = 0.0;
  float n = 0.3 * (float)(N);
  for (i = 1.0; i < n; i = i + 0.01) {
    t1 = hypot(i, j);
    t2 = hypot(i, j);
    t3 = hypot(i, j);
    t4 = hypot(i, j);
    t5 = hypot(i, j);
    t6 = hypot(i, j);
    t7 = hypot(i, j);
    t8 = hypot(i, j);
    t9 = hypot(i, j);
    t10 = hypot(i, j);
  }
  *result_hypot = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}