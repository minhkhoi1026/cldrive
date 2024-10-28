//{"N":1,"result_cos":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_cos_withoutDD1(global float* result_cos, int N) {
  float t1 = 1.23;
  float t2 = 1.23;
  float t3 = t1;
  float t4 = t3;
  float t5 = t4;
  float t6 = t5;
  float t7 = t6;
  float j = 0.0;
  for (j = 0.0; j < 10 * N; j = j + 1.0) {
    t1 = cos(j);
    t2 = cos(j);
    t3 = cos(j);
    t4 = cos(j);
    t5 = cos(j);
    t6 = cos(j);
    t7 = cos(j);
  }
  *result_cos = t1 + t2 + t3 + t4 + t5 + t6 + t7;
}