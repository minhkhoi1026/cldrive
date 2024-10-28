//{"N":1,"result_erf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_erf_withoutDD1(global float* result_erf, int N) {
  float t1 = 1.23;
  float t2 = 1.23;
  float t3 = 1.23;
  float t4 = 1.23;
  float t5 = 1.23;
  float t6 = 1.23;
  float t7 = 1.23;

  float i = 1.0;
  for (i = 1.0; i < N; i = i + 1.0) {
    t1 = erf(i + 0.1);
    t2 = erf(i + 0.2);
    t3 = erf(i + 0.3);
    t4 = erf(i + 0.4);
    t5 = erf(i + 0.5);
    t6 = erf(i + 0.6);
    t7 = erf(i + 0.7);
  }
  *result_erf = t1 + t2 + t3 + t4 + t5 + t6 + t7;
}