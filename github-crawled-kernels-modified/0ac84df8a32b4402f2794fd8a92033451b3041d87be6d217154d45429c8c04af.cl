//{"N":2,"p1":0,"result_div":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_div_withDD8(float p1, global float* result_div, int N) {
  float t1 = p1;
  float8 t2 = t1 + (float8)(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7);
  int i = 0;
  for (i = 0; i < N; i++) {
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    t2 /= 1.0f;
    ;
  }
  *result_div = t2.s0 + t2.s1 + t2.s2 + t2.s3 + t2.s4 + t2.s5 + t2.s6 + t2.s7;
}