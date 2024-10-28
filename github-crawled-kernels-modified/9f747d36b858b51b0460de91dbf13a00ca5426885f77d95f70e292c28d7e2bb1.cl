//{"N":1,"result_log10":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_log10_withoutDD1(global float* result_log10, int N) {
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

  float i = 0.0;
  float n = 7 * (float)(N);

  for (i = 0.0; i < n; i = i + 1.0) {
    t1 = log10(i);
    t2 = log10(i);
    t3 = log10(i);
    t4 = log10(i);
    t5 = log10(i);
    t6 = log10(i);
    t7 = log10(i);
    t8 = log10(i);
    t9 = log10(i);
    t10 = log10(i);
  }
  *result_log10 = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}