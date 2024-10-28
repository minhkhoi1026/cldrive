//{"N":1,"result_frexp":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_frexp_withoutDD1(global float* result_frexp, int N) {
  float t1 = 1.23;
  float t2 = 1.23;
  float t3 = 1.23;
  float t4 = 1.23;
  float t5 = 1.23;
  float t6 = 1.23;
  float t7 = 1.23;
  float t8 = 1.23;
  float t9 = 1.23;
  float t10 = 1.23;

  float i = 1.0;
  int iptr = 0;
  float n = 10 * (float)(N);

  for (i = 1.0; i < n; i = i + 1.0) {
    t1 = frexp(i, &iptr);
    t2 = frexp(i, &iptr);
    t3 = frexp(i, &iptr);
    t4 = frexp(i, &iptr);
    t5 = frexp(i, &iptr);
    t6 = frexp(i, &iptr);
    t7 = frexp(i, &iptr);
    t8 = frexp(i, &iptr);
    t9 = frexp(i, &iptr);
    t10 = frexp(i, &iptr);
  }
  *result_frexp = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}