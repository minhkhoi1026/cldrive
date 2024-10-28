//{"N":1,"result_atan":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_atan_withoutDD1(global float* result_atan, int N) {
  float t1 = 1.23;
  float t2 = t1;
  float t3 = t1;
  float t4 = t3;
  float t5 = t3;
  float t6 = t3;
  float t7 = t3;
  float t8 = t3;
  float t9 = t3;
  float t10 = t3;
  float j = 1.0;
  for (j = 0.0; j <= 7 * N; j = j + 1.0) {
    t1 = atan(j);
    t2 = atan(j);
    t3 = atan(j);
    t4 = atan(j);
    t5 = atan(j);
    t6 = atan(j);
    t7 = atan(j);
    t8 = atan(j);
    t9 = atan(j);
    t10 = atan(j);
  }
  *result_atan = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}