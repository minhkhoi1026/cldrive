//{"n":1,"result_cbrt":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_cbrt_withoutDD1(global float* result_cbrt, int n) {
  float p1 = 1.0;
  float p2 = 1.0;
  float p3 = 1.0;
  float p4 = 1.0;
  float p5 = 1.0;
  float p6 = 1.0;
  float p7 = 1.0;
  float p8 = 1.0;
  float p9 = 1.0;
  float p10 = 1.0;

  float i = 0.0;
  float N = 3 * (float)(n);

  for (i = 0.0; i < N; i = i + 1.0) {
    p1 = cbrt(i + 0.01);
    p2 = cbrt(i + 0.02);
    p3 = cbrt(i + 0.03);
    p4 = cbrt(i + 0.04);
    p5 = cbrt(i + 0.05);
    p6 = cbrt(i + 0.06);
    p7 = cbrt(i + 0.07);
    p8 = cbrt(i + 0.08);
    p9 = cbrt(i + 0.09);
    p10 = cbrt(i + 0.1);
  }
  *result_cbrt = p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9 + p10;
}