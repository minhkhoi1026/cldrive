//{"N":1,"result_sin":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_sin_withDD8(global float* result_sin, int N) {
  float t1 = 1.0;
  float8 t2 = t1 + (float8)(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7);
  int i = 0;
  for (i = 0; i < N; i++) {
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    t2 = sin(t2);
    ;
  }
  *result_sin = t2.s0 + t2.s1 + t2.s2 + t2.s3 + t2.s4 + t2.s5 + t2.s6 + t2.s7;
}