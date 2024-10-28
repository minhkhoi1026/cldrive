//{"N":1,"result_log":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_log_withoutDD1(global float* result_log, int N) {
  float t1 = 0.0;
  float t2 = 0.0;
  float t3 = t1;
  float t4 = t3;
  float t5 = t4;
  float t6 = t5;
  float t7 = t6;
  float t8 = t7;
  float t9 = t8;
  float t10 = t9;
  float t11 = 0.0;
  float t12 = 0.0;

  float i = 1.0;
  float p = 256 * N;

  for (i = 1.0; i <= p; i = i + 1.0) {
    t1 += log(i);
    t2 += log(i);
    t3 += log(i);
    t4 += log(i);
    t5 += log(i);
    t6 += log(i);
    t7 += log(i);
    t8 += log(i);
    t9 += log(i);
    t10 += log(i);
    t11 += log(i);
    t12 += log(i);
  }

  *result_log = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12;
}