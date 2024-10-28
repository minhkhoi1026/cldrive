//{"N":1,"result_ldexp":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_ldexp_withoutDD1(global float* result_ldexp, int N) {
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
  int j = 1.0;
  float n = 10 * (float)(N);
  for (i = 0.0; i < n; i = i + 1.0) {
    t1 = ldexp(i, j);
    t2 = ldexp(i, j);
    t3 = ldexp(i, j);
    t4 = ldexp(i, j);
    t5 = ldexp(i, j);
    t6 = ldexp(i, j);
    t7 = ldexp(i, j);
    t8 = ldexp(i, j);
    t9 = ldexp(i, j);
    t10 = ldexp(i, j);
  }
  *result_ldexp = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}