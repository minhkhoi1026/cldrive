//{"n":1,"result_fdim":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_fdim_withoutDD1(global float* result_fdim, int n) {
  float p1 = -12.9;
  float p2 = -19.1;
  float p3 = -19.1;
  float p4 = -19.1;
  float p5 = -19.1;
  float p6 = -19.1;
  float p7 = -19.1;
  float p8 = -19.1;
  float p9 = -19.1;
  float p10 = -19.1;
  float k1 = 0.01;
  float k2 = 0.02;
  float k3 = 0.03;
  float k4 = 0.04;
  float k5 = 0.05;
  float k6 = 0.06;
  float k7 = 0.07;
  float k8 = 0.08;
  float k9 = 0.09;
  float k10 = 0.1;

  float i = 0.0;
  float j = 13.63;
  float N = (float)(n);

  for (i = 0.0; i < 0.1 * N; i = i + 0.01) {
    p1 += fdim(i, k1 + j);
    p2 += fdim(i, k2 + j);
    p3 += fdim(i, k3 + j);
    p4 += fdim(i, k4 + j);
    p5 += fdim(i, k5 + j);
    p6 += fdim(i, k6 + j);
    p7 += fdim(i, +k7 + j);
  }
  *result_fdim = p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9 + p10;
}