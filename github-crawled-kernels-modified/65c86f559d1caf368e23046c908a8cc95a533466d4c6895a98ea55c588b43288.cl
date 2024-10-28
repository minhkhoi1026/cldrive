//{"N":1,"result_log1p":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_log1p_withoutDD1(global float* result_log1p, int N) {
  float t1;
  float t2;
  float t3;
  float t4;
  float t5;
  float t6;
  float t7;

  float i = 0.0;
  float n = 100 * N;
  for (i = 0.0; i < n; i = i + 1.0) {
    t1 = log1p(i);
    t2 = log1p(i);
    t3 = log1p(i);
    t4 = log1p(i);
    t5 = log1p(i);
    t6 = log1p(i);
    t7 = log1p(i);
  }
  *result_log1p = t1 + t2 + t3 + t4 + t5 + t6 + t7;
}