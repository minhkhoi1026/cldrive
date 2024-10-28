//{"N":1,"result_sinh":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_sinh_withoutDD1(global float* result_sinh, int N) {
  float t1 = 0.123;
  float t2 = 1.0;
  float t3 = t2;
  float t4 = t3;
  float t5 = t4;
  float t6 = t5;
  float t7 = t6;
  float t8 = t7;
  float t9 = t8;
  float t10 = t9;
  float p1 = 0.01;
  float p2 = 0.02;
  float p3 = 0.03;
  float p4 = 0.04;
  float p5 = 0.05;
  float p6 = 0.06;
  float p7 = 0.07;
  float p8 = 0.08;
  float p9 = 0.09;
  float p10 = 0.1;
  float i = 0.0;
  for (i = 0.0; i < 0.005 * N; i = i + 0.0001) {
    t1 = sinh(i + p1);
    t2 = sinh(i + p2);
    t3 = sinh(i + p3);
    t4 = sinh(i + p4);
    t5 = sinh(i + p5);
    t6 = sinh(i + p6);
    t7 = sinh(i + p7);
    t8 = sinh(i + p8);
    t9 = sinh(i + p9);
    t10 = sinh(i + p10);
  }
  *result_sinh = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}