//{"N":1,"result_sincos":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_sincos_withDD1(global float* result_sincos, int N) {
  float t1 = 1.0;
  float t2;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    t1 = sincos(t1, &t2);
    ;
  }
  *result_sincos = t1;
}