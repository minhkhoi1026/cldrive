//{"N":1,"result_tanh":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_tanh_withoutDD1(global float* result_tanh, int N) {
  float t1 = 0.234;
  float t2 = 1.1;
  float t3 = t2;
  float t4 = t3;
  float t5 = t4;
  float t6 = t5;
  float t7 = t6;
  float t8 = t7;
  float t9 = t8;
  float t10 = t9;

  float i = 0.0;
  for (i = 0.0; i < 0.005 * N; i = i + 0.0001) {
    t1 = tanh(i + 0.01);
    t2 = tanh(i + 0.02);
    t3 = tanh(i + 0.03);
    t4 = tanh(i + 0.04);
    t5 = tanh(i + 0.05);
    t6 = tanh(i + 0.06);
    t7 = tanh(i + 0.07);
    t8 = tanh(i + 0.08);
    t9 = tanh(i + 0.09);
    t10 = tanh(i + 0.1);
  }
  *result_tanh = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}