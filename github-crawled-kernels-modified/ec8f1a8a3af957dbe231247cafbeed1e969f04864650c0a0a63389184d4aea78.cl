//{"N":1,"result_round":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_round_withoutDD1(global float* result_round, int N) {
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
  float n = 0.3 * (float)(N);
  for (i = 1.0; i < n; i = i + 0.01) {
    t1 = round(i);
    t2 = round(i + 0.02);
    t3 = round(i + 0.01);
    t4 = round(i + 0.03);
    t5 = round(i + 0.04);
    t6 = round(i + 0.05);
    t7 = round(i + 0.06);
    t8 = round(i + 0.07);
    t9 = round(i + 0.08);
    t10 = round(i + 0.09);
  }
  *result_round = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}