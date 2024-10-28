//{"N":1,"result_tgamma":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_tgamma_withDD1(global float* result_tgamma, int N) {
  float t1 = 1.3;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    t1 = tgamma(t1);
    ;
  }

  *result_tgamma = t1;
}