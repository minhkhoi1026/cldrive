//{"N":1,"result_cosh":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_cosh_withDD1(global float* result_cosh, int N) {
  float t1 = 2.0;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    t1 = cosh(t1 - 1.0);
    ;
  }
  *result_cosh = t1;
}