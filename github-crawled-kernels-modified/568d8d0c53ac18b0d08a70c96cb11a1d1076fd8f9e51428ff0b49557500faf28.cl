//{"N":1,"result_acospi":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_acospi_withDD1(global float* result_acospi, int N) {
  float t1 = 0.4;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    t1 = acospi(t1);
    ;
  }
  *result_acospi = t1;
}