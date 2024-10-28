//{"N":1,"result_expm1":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_expm1_withDD1(global float* result_expm1, int N) {
  float t1 = 0.0;
  int i = 0;
  for (i = 0; i < 10 * N; i++) {
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    t1 = expm1(t1) - 1.0;
    ;
  }
  *result_expm1 = t1;
}