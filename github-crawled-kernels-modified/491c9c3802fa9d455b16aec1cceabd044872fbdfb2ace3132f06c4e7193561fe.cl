//{"N":1,"result_asinpi":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_asinpi_withDD1(global float* result_asinpi, int N) {
  float t1 = 0.43;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    t1 = asinpi(t1);
    ;
  }
  *result_asinpi = t1;
}