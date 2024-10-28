//{"N":1,"result_atan2":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_atan2_withoutDD1(global float* result_atan2, int N) {
  float t1 = 12345.64;
  float t2 = 12345.64;
  float t3 = 12345.64;
  float t4 = 12345.64;
  float t5 = 12345.64;
  float t6 = 12345.64;
  float t7 = 12345.64;
  float t8 = 12345.64;
  float t9 = 12345.64;
  float t10 = 12345.64;

  float i = 0.0;
  float j = 0.01;
  float n = (float)(N);
  for (i = 0.0; i < n; i = i + 0.1) {
    t1 = atan2(i, j);
    t2 = atan2(i, j);
    t3 = atan2(i, j);
    t4 = atan2(i, j);
    t5 = atan2(i, j);
    t6 = atan2(i, j);
    t7 = atan2(i, j);
    t8 = atan2(i, j);
    t9 = atan2(i, j);
    t10 = atan2(i, j);
  }
  *result_atan2 = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}