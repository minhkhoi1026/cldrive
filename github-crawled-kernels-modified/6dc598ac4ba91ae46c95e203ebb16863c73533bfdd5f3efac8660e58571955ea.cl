//{"N":1,"result_mad":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_mad_withoutDD1(global float* result_mad, int N) {
  float t1 = 0.0;
  float t2 = 0.0;
  float t3 = 0.0;
  float t4 = 0.0;
  float t5 = 0.0;
  float t6 = 0.0;
  float t7 = 0.0;
  float t8 = 0.0;
  float t9 = 0.0;
  float t10 = 0.0;
  float t11 = 0.0;
  float t12 = 0.0;
  float t13 = 0.0;
  float t14 = 0.0;
  float t15 = 0.0;
  float i = 0.0;
  float p = 512 * N;
  for (i = 0.0; i < p; i = i + 1.0) {
    t1 = mad(t1, i, t1);
    t2 = mad(t2, i, t2);
    t3 = mad(t3, i, t3);
    t4 = mad(t4, i, t4);
    t5 = mad(t5, i, t5);
    t6 = mad(t6, i, t6);
    t7 = mad(t7, i, t7);
    t8 = mad(t8, i, t8);
    t9 = mad(t9, i, t9);
    t10 = mad(t10, i, t10);
    t11 = mad(t11, i, t11);
    t12 = mad(t12, i, t12);
    t13 = mad(t13, i, t13);
    t14 = mad(t14, i, t14);
    t15 = mad(t15, i, t15);
  }
  *result_mad = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10 + t11 + t12 + t13 + t14 + t15;
}