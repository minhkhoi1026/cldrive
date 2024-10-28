//{"N":1,"result_cosh":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_cosh_withoutDD1(global float* result_cosh, int N) {
  float t1 = 0.123;
  float t2 = 0.12;
  float t3 = t2;
  float t4 = t3;
  float t5 = t4;
  float t6 = t5;
  float t7 = t6;
  float t8 = t7;
  float t9 = t8;
  float t10 = t9;
  float p1 = 0.001;
  float p2 = 0.002;
  float p3 = 0.003;
  float p4 = 0.004;
  float p5 = 0.005;
  float p6 = 0.006;
  float p7 = 0.007;

  float i = 0.0;
  for (i = 0.0; i < 0.0256 * N; i = i + 0.001) {
    t1 += cosh(i);
    t2 += cosh(i + p1);
    t3 += cosh(i + p2);
    t4 += cosh(i + p3);
    t5 += cosh(i + p4);
    t6 += cosh(i + p5);
    t7 += cosh(i + p6);
  }
  *result_cosh = t1 + t2 + t3 + t4 + t5 + t6 + t7;
}