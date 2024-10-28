//{"N":1,"result_asin":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_asin_withoutDD1(global float* result_asin, int N) {
  float t1 = 1.0;
  float t2 = 1.1;
  float t3 = 1.2;
  float t4 = 1.3;
  float t5 = 1.4;
  float t6 = 1.5;
  float t7 = 1.6;
  float t8 = 1.6;
  float t9 = 1.7;
  float t10 = 1.8;

  float p1 = 0.0;
  for (p1 = 0.0; p1 < 1.0; p1 = p1 + 0.0001) {
    t1 += asin(p1);
    t2 += asin(p1 - 0.00001);
    t3 += asin(p1 - 0.00002);
    t4 += asin(p1 - 0.00003);
    t5 += asin(p1 - 0.00003);
    t6 += asin(p1 - 0.00003);
    t7 += asin(p1 - 0.00003);
    t8 += asin(p1 - 0.00003);
  }
  *result_asin = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}