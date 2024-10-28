//{"N":1,"result_tan":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_tan_withoutDD1(global float* result_tan, int N) {
  float t1 = 1.23;
  float t2 = 1.1;
  float t3 = t1;
  float t4 = t3;
  float t5 = t4;
  float t6 = t5;
  float t7 = t6;
  float t8 = t7;

  float j = 1.0;
  for (j = 0.0; j < 10 * N; j = j + 1.0) {
    t1 = tan(j);
    t2 = tan(j);
    t3 = tan(j);
    t4 = tan(j);
    t5 = tan(j);
    t6 = tan(j);
    t7 = tan(j);
    t8 = tan(j);
  }
  *result_tan = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8;
}