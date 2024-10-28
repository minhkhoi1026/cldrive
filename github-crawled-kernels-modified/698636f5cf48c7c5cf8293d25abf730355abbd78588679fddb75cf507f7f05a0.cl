//{"N":1,"result_erf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_erf_withDD1(global float* result_erf, int N) {
  float t1 = 1.1;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    t1 = erf(t1);
    ;
  }
  *result_erf = t1;
}