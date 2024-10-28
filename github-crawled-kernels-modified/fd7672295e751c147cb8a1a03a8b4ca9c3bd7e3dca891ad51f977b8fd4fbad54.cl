//{"N":1,"result_log1p":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_log1p_withDD1(global float* result_log1p, int N) {
  float t1 = 2.1;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    t1 = log1p(t1);
    ;
  }
  *result_log1p = t1;
}