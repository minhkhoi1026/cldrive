//{"N":1,"result_sinpi":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_sinpi_withDD1(global float* result_sinpi, int N) {
  float t1 = 4.3;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    t1 = sinpi(t1);
    ;
  }
  *result_sinpi = t1;
}