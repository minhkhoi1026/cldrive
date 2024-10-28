//{"n":1,"result_floor":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_floor_withoutDD1(global float* result_floor, int n) {
  float p1 = 5.64;
  float p2 = 45.64;
  float p3 = 5.64;
  float p4 = 5.64;
  float p5 = 5.64;
  float p6 = 5.64;
  float p7 = 5.64;
  float p8 = 5.64;
  float p9 = 5.64;
  float p10 = 5.64;
  float p11 = 5.64;
  float p12 = 45.64;
  float p13 = 5.64;
  float p14 = 5.64;
  float p15 = 5.64;
  float p16 = 5.64;
  float p17 = 5.64;
  float p18 = 5.64;
  float p19 = 5.64;
  float p20 = 5.64;
  float p21 = 5.64;
  float p22 = 45.64;
  float p23 = 5.64;
  float p24 = 5.64;
  float p25 = 5.64;
  float p26 = 5.64;
  float p27 = 5.64;
  float p28 = 5.64;
  float p29 = 5.64;
  float p30 = 5.64;
  float p31 = 5.64;
  float p32 = 45.64;
  float p33 = 5.64;
  float p34 = 5.64;
  float p35 = 5.64;
  float p36 = 5.64;
  float p37 = 5.64;
  float p38 = 5.64;
  float p39 = 5.64;
  float p40 = 5.64;

  float i = 0.0;
  float N = 0.256 * n;

  for (i = 0.0; i < N; i = i + 0.001) {
    p1 += floor(i - 2.1);
    p2 += floor(i - 1.4);
    p3 += floor(i - 1.4);
    p4 += floor(i - 3.5);
    p5 += floor(i - 4.56);
    p6 += floor(i - 5.4);
    p7 += floor(i - 3.5);
    p8 += floor(i - 2.4);
    p9 += floor(i - 3.4);
    p10 += floor(i - 0.2);
    p11 += floor(i - 2.1);
    p12 += floor(i - 1.4);
    p13 += floor(i - 1.4);
    p14 += floor(i - 3.5);
    p15 += floor(i - 4.56);
    p16 += floor(i - 5.4);
    p17 += floor(i - 3.5);
    p18 += floor(i - 2.4);
    p19 += floor(i - 3.4);
    p20 += floor(i - 0.2);
    p21 += floor(i - 2.1);
    p22 += floor(i - 1.4);
    p23 += floor(i - 1.4);
    p24 += floor(i - 3.5);
    p25 += floor(i - 4.56);
    p26 += floor(i - 5.4);
    p27 += floor(i - 3.5);
    p28 += floor(i - 2.4);
    p29 += floor(i - 3.4);
    p30 += floor(i - 0.2);
    p31 += floor(i - 2.1);
    p32 += floor(i - 1.4);
    p33 += floor(i - 1.4);
    p34 += floor(i - 3.5);
    p35 += floor(i - 4.56);
    p36 += floor(i - 5.4);
    p37 += floor(i - 3.5);
    p38 += floor(i - 2.4);
    p39 += floor(i - 3.4);
    p40 += floor(i - 0.2);
  }
  *result_floor = p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9 + p10 + p11 + p12 + p13 + p14 + p15 + p16 + p17 + p18 + p19 + p20 + p21 + p22 + p23 + p24 + p25 + p26 + p27 + p28 + p29 + p30 + p31 + p32 + p33 + p34 + p35 + p36 + p37 + p38 + p39 + p40;
}