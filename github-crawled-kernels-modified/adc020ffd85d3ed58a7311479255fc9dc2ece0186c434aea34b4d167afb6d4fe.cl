//{"N":1,"result_tgamma":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_tgamma_withoutDD1(global float* result_tgamma, int N) {
  float t1;
  float t2;
  float t3;
  float t4;
  float t5;
  float t6;
  float t7;
  float t8;
  float t9;
  float t10;

  float i = 1.0;
  float n = 0.07 * (float)(N);
  for (i = 1.0; i < n; i = i + 0.01) {
    t1 = tgamma(i);
    t2 = tgamma(i);
    t3 = tgamma(i);
    t4 = tgamma(i);
    t5 = tgamma(i);
    t6 = tgamma(i);
    t7 = tgamma(i);
    t8 = tgamma(i);
    t9 = tgamma(i);
    t10 = tgamma(i);
  }
  *result_tgamma = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}