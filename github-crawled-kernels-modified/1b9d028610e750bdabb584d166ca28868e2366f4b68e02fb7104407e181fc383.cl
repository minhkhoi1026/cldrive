//{"N":1,"result_lgamma":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_lgamma_withDD1(global float* result_lgamma, int N) {
  float t1 = 0.2;

  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    t1 = lgamma(t1) - 1.3;
    ;
  }

  *result_lgamma = t1;
}