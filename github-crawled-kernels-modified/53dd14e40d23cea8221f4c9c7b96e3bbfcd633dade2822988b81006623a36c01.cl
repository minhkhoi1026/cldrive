//{"n":1,"result_ceil":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_ceil_withoutDD1(global float* result_ceil, int n) {
  float p1 = 1.23;
  float p2 = 1.23;
  float p3 = 1.23;
  float p4 = 1.23;
  float p5 = 1.23;
  float p6 = 1.23;
  float p7 = 1.23;
  float p8 = 1.23;
  float p9 = 1.23;
  float p10 = 1.23;
  float p11 = 1.23;
  float p12 = 1.23;
  float p13 = 1.23;
  float p14 = 1.23;
  float p15 = 1.23;
  float p16 = 1.23;
  float p17 = 1.23;
  float p18 = 1.23;
  float p19 = 1.23;
  float p20 = 1.23;
  float p21 = 1.23;
  float p22 = 1.23;
  float p23 = 1.23;
  float p24 = 1.23;
  float p25 = 1.23;
  float p26 = 1.23;
  float p27 = 1.23;
  float p28 = 1.23;
  float p29 = 1.23;
  float p30 = 1.23;
  float p31 = 1.23;
  float p32 = 1.23;
  float p33 = 1.23;
  float p34 = 1.23;
  float p35 = 1.23;
  float p36 = 1.23;
  float p37 = 1.23;
  float p38 = 1.23;
  float p39 = 1.23;
  float p40 = 1.23;

  float i = 0.0;
  float N = 256.0 * n;

  for (i = 0.0; i < N; i = i + 1.0) {
    p1 += ceil(i + 0.001);
    p2 += ceil(i + 0.002);
    p3 += ceil(i + 0.003);
    p4 += ceil(i + 0.005);
    p5 += ceil(i + 0.006);
    p6 += ceil(i + 0.007);
    p7 += ceil(i + 0.008);
    p8 += ceil(i + 0.009);
    p9 += ceil(i + 0.012);
    p10 += ceil(i + 0.031);
    p11 += ceil(i + 0.001);
    p12 += ceil(i + 0.002);
    p13 += ceil(i + 0.003);
    p14 += ceil(i + 0.005);
    p15 += ceil(i + 0.006);
    p16 += ceil(i + 0.007);
    p17 += ceil(i + 0.008);
    p18 += ceil(i + 0.009);
    p19 += ceil(i + 0.012);
    p20 += ceil(i + 0.031);
    p21 += ceil(i + 0.001);
    p22 += ceil(i + 0.002);
    p23 += ceil(i + 0.003);
    p24 += ceil(i + 0.005);
    p25 += ceil(i + 0.006);
    p26 += ceil(i + 0.007);
    p27 += ceil(i + 0.008);
    p28 += ceil(i + 0.009);
    p29 += ceil(i + 0.012);
    p30 += ceil(i + 0.031);
    p31 += ceil(i + 0.001);
    p32 += ceil(i + 0.002);
    p33 += ceil(i + 0.003);
    p34 += ceil(i + 0.005);
    p35 += ceil(i + 0.006);
    p36 += ceil(i + 0.007);
    p37 += ceil(i + 0.008);
    p38 += ceil(i + 0.009);
    p39 += ceil(i + 0.012);
    p40 += ceil(i + 0.031);
  }
  *result_ceil = p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9 + p10 + p11 + p12 + p13 + p14 + p15 + p16 + p17 + p18 + p19 + p20 + p21 + p22 + p23 + p24 + p25 + p26 + p27 + p28 + p29 + p30 + p31 + p32 + p33 + p34 + p35 + p36 + p37 + p38 + p39 + p40;
}