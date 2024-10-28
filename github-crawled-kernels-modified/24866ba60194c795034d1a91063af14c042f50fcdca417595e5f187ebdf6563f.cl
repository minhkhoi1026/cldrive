//{"N":1,"result_exp":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_exp_withoutDD1(global float* result_exp, int N) {
  float t1 = 1.1;
  float t2 = 1.1;
  float t3 = t1;
  float t4 = t3;
  float t5 = t4;
  float t6 = t5;
  float t7 = t6;
  float t8 = t7;
  float t9 = t8;
  float t10 = t9;
  float t11 = 1.1;
  float t12 = 1.1;

  float p = 0.0;
  for (p = 0.0; p < 0.0256 * N; p = p + 0.0001) {
    t1 += exp(p);
    t2 += exp(p + 0.01);
    t3 += exp(p + 0.02);
    t4 += exp(p + 0.03);
    t5 += exp(p + 0.04);
    t6 += exp(p + 0.05);
    t7 += exp(p + 0.06);
    t8 += exp(p + 0.07);
    t9 += exp(p + 0.08);
    t10 += exp(p + 0.09);
    t11 += exp(p + 0.11);
    t12 += exp(p + 0.12);
  }
  *result_exp = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12;
}