//{"N":1,"result_sin":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_sin_withoutDD1(global float* result_sin, int N) {
  float t1 = 1.23;
  float t2 = 1.23;
  float t3 = 1.2;
  float t4 = 1.2;
  float t5 = 1.2;
  float t6 = 1.2;
  float t7 = 1.2;
  float j = 0.0;

  for (j = 0.0; j < 10 * N; j = j + 1.0) {
    t1 = sin(j);
    t2 = sin(j);
    t3 = sin(j);
    t4 = sin(j);
    t5 = sin(j);
    t6 = sin(j);
    t7 = sin(j);
  }
  *result_sin = t1 + t2 + t3 + t4 + t5 + t6 + t7;
}