//{"N":1,"result_trunc":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_trunc_withDD1(global float* result_trunc, int N) {
  float t1 = -1.3;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    t1 = trunc(t1 + 0.01);
    ;
  }

  *result_trunc = t1;
}