//{"N":1,"result_remainder":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_remainder_withoutDD1(global float* result_remainder, int N) {
  float t1;
  float t2;
  float t3;
  float t4;
  float t5;
  float t6;
  float t7;
  float t8;
  float t9;
  float t10;

  float i = 1.0;
  float j = 1.0;
  float n = (float)(N);
  for (i = 1.0; i < n; i = i + 1.0) {
    t1 = remainder(i, j);
    t2 = remainder(i, j);
    t3 = remainder(i, j);
    t4 = remainder(i, j);
    t5 = remainder(i, j);
    t6 = remainder(i, j);
    t7 = remainder(i, j);
    t8 = remainder(i, j);
    t9 = remainder(i, j);
    t10 = remainder(i, j);
  }
  *result_remainder = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}