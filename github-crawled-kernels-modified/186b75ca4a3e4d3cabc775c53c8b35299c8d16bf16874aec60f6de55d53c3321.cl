//{"N":1,"result_cospi":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_cospi_withDD1(global float* result_cospi, int N) {
  float t1 = 4.3;
  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    t1 = cospi(t1);
    ;
  }
  *result_cospi = t1;
}