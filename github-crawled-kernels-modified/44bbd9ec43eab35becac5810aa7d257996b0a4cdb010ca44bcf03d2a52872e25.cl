//{"n":1,"result_fabs":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_fabs_withoutDD1(global float* result_fabs, int n) {
  float p1 = -2.3;
  float p2 = -2.3;
  float p3 = -2.3;
  float p4 = -2.3;
  float p5 = -2.3;
  float p6 = -2.3;
  float p7 = -2.3;
  float p8 = -2.3;
  float p9 = -2.3;
  float p10 = -2.3;
  float p11 = -2.3;
  float p12 = -2.3;
  float p13 = -2.3;
  float p14 = -2.3;
  float p15 = -2.3;
  float p16 = -2.3;
  float p17 = -2.3;
  float p18 = -2.3;
  float p19 = -2.3;
  float p20 = -2.3;
  float p21 = -2.3;
  float p22 = -2.3;
  float p23 = -2.3;
  float p24 = -2.3;
  float p25 = -2.3;
  float p26 = -2.3;
  float p27 = -2.3;
  float p28 = -2.3;
  float p29 = -2.3;
  float p30 = -2.3;

  float i = 0.0;
  float N = 256.0 * (float)(n);
  for (i = 0.0; i < N; i = i + 1.0) {
    p1 += fabs(i);
    p2 += fabs(i - 0.34);
    p3 += fabs(i - 36);
    p4 += fabs(i - 57);
    p5 += fabs(i - 24);
    p6 += fabs(i - 26);
    p7 += fabs(i - 36);
    p8 += fabs(i - 44);
    p9 += fabs(i - 26);
    p10 += fabs(i - 22);
    p11 += fabs(i);
    p12 += fabs(i - 0.34);
    p13 += fabs(i - 36);
    p14 += fabs(i - 57);
    p15 += fabs(i - 24);
    p16 += fabs(i - 26);
    p17 += fabs(i - 36);
    p18 += fabs(i - 44);
    p19 += fabs(i - 26);
    p20 += fabs(i - 22);
    p21 += fabs(i - 8);
    p22 += fabs(i - 0.34);
    p23 += fabs(i - 36);
    p24 += fabs(i - 57);
    p25 += fabs(i - 24);
    p26 += fabs(i - 26);
    p27 += fabs(i - 36);
    p28 += fabs(i - 44);
    p29 += fabs(i - 26);
    p30 += fabs(i - 22);
  }
  *result_fabs = p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9 + p10 + p11 + p12 + p13 + p14 + p15 + p16 + p17 + p18 + p19 + p20 + p21 + p22 + p23 + p24 + p25 + p26 + p27 + p28 + p29 + p30;
}