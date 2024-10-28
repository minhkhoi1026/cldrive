//{"n":1,"result_copysign":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_copysign_withoutDD1(global float* result_copysign, int n) {
  float p1 = 1.2;
  float p2 = 1.2;
  float p3 = 1.2;
  float p4 = 1.2;
  float p5 = 1.2;
  float p6 = 1.2;
  float p7 = 1.2;
  float p8 = 1.2;
  float p9 = 1.2;
  float p10 = 1.2;
  float p11 = 1.2;
  float p12 = 1.2;
  float p13 = 1.2;
  float p14 = 1.2;
  float p15 = 1.2;
  float p16 = 1.2;
  float p17 = 1.2;
  float p18 = 1.2;
  float p19 = 1.2;
  float p20 = 1.2;
  float p21 = 1.2;
  float p22 = 1.2;
  float p23 = 1.2;
  float p24 = 1.2;
  float p25 = 1.2;
  float p26 = 1.2;
  float p27 = 1.2;
  float p28 = 1.2;
  float p29 = 1.2;
  float p30 = 1.2;

  float i = 1.0;
  float j = 2.2;
  float N = 100.0 * (float)(n);

  for (i = 1.0; i < N; i = i + 1.0) {
    p1 += copysign(i - 345, j);
    p2 += copysign(i - 234, j);
    p3 += copysign(i - 23, j);
    p4 += copysign(i - 24, j);
    p5 += copysign(i - 25, j);
    p6 += copysign(i - 64, j);
    p7 += copysign(i - 57, j);
    p8 += copysign(i - 22, j);
    p9 += copysign(i - 256, j);
    p10 += copysign(i - 46, j);
    p11 += copysign(i - 345, j);
    p12 += copysign(i - 234, j);
    p13 += copysign(i - 23, j);
    p14 += copysign(i - 24, j);
    p15 += copysign(i - 25, j);
    p16 += copysign(i - 64, j);
    p17 += copysign(i - 57, j);
    p18 += copysign(i - 22, j);
    p19 += copysign(i - 256, j);
    p20 += copysign(i - 46, j);
    p21 += copysign(i - 345, j);
    p22 += copysign(i - 234, j);
    p23 += copysign(i - 23, j);
    p24 += copysign(i - 24, j);
    p25 += copysign(i - 25, j);
    p26 += copysign(i - 64, j);
    p27 += copysign(i - 57, j);
    p28 += copysign(i - 22, j);
    p29 += copysign(i - 256, j);
    p30 += copysign(i - 46, j);
  }
  *result_copysign = p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9 + p10 + p11 + p12 + p13 + p14 + p15 + p16 + p17 + p18 + p19 + p20 + p21 + p22 + p23 + p24 + p25 + p26 + p27 + p28 + p29 + p30;
}