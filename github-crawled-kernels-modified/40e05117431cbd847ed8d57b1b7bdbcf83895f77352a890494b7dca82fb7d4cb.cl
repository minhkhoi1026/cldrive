//{"N":1,"result_erfc":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_erfc_withoutDD1(global float* result_erfc, int N) {
  float t1 = 1.0;
  float t2 = 1.0;
  float t3 = 1.0;
  float t4 = 1.0;
  float t5 = 1.0;
  float t6 = 1.0;
  float t7 = 1.0;
  float t8 = 1.0;
  float t9 = 1.0;
  float t10 = 1.0;

  float i = 0.0;
  float j;
  float n = 7 * N;

  for (i = 0.0; i < n; i = i + 1.0) {
    t1 = erfc(i);
    t2 = erfc(i);
    t3 = erfc(i);
    t4 = erfc(i);
    t5 = erfc(i);
    t6 = erfc(i);
    t7 = erfc(i);
    t8 = erfc(i);
    t9 = erfc(i);
    t10 = erfc(i);
  }
  *result_erfc = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}