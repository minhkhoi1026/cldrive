//{"N":1,"result_log10":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_log10_withDD1(global float* result_log10, int N) {
  float t1 = 1.34;

  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    t1 = log10((t1 + 0.1) / t1);
    ;
  }
  *result_log10 = t1;
}