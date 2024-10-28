//{"N":1,"result_cbrt":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_cbrt_withDD1(global float* result_cbrt, int N) {
  float p1 = 345.634;
  int i = 0;
  for (i = 0; i < N; i++) {
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    p1 = cbrt(p1);
    ;
  }
  *result_cbrt = p1;
}