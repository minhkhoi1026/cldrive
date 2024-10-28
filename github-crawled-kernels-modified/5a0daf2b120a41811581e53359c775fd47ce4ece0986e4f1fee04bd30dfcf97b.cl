//{"N":1,"result_atanpi":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_atanpi_withDD1(global float* result_atanpi, int N) {
  float t1 = 12345.64;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    t1 = atanpi(t1);
    ;
  }
  *result_atanpi = t1;
}