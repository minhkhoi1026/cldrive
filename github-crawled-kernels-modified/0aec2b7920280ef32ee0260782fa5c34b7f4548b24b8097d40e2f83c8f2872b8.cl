//{"N":1,"result_atan2pi":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_atan2pi_withoutDD1(global float* result_atan2pi, int N) {
  float t1 = 2.2;
  float t2 = 2.0;
  float t3 = 2.3;
  float t4 = 2.3;
  float t5 = 2.3;
  float t6 = 2.3;
  float t7 = 2.3;
  float t8 = 2.3;
  float t9 = 2.3;
  float t10 = 2.3;

  float i = 0.0;
  float j = 0.01;
  float n = (float)(N);
  for (i = 0.0; i < n; i = i + 0.1) {
    t1 = atan2pi(i, j);
    t2 = atan2pi(i, j);
    t3 = atan2pi(i, j);
    t4 = atan2pi(i, j);
    t5 = atan2pi(i, j);
    t6 = atan2pi(i, j);
    t7 = atan2pi(i, j);
    t8 = atan2pi(i, j);
    t9 = atan2pi(i, j);
    t10 = atan2pi(i, j);
  }
  *result_atan2pi = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}