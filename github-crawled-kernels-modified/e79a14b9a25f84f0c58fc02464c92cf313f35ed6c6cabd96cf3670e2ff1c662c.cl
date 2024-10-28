//{"N":1,"result_lgamma":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_lgamma_withoutDD1(global float* result_lgamma, int N) {
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

  float i = 0.0;

  for (i = 0.0; i < 1.0; i = i + 0.1) {
    t1 = lgamma(i);
    t2 = lgamma(i + 0.01);
    t3 = lgamma(i + 0.02);
    t4 = lgamma(i + 0.03);
    t5 = lgamma(i + 0.04);
    t6 = lgamma(i + 0.05);
    t7 = lgamma(i + 0.06);
    t8 = lgamma(i + 0.07);
    t9 = lgamma(i + 0.08);
    t10 = lgamma(i + 0.09);
  }
  *result_lgamma = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}