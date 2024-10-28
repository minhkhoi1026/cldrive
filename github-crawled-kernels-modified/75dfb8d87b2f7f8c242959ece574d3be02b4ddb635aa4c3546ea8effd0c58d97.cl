//{"N":1,"result_asinh":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_asinh_withDD1(global float* result_asinh, int N) {
  float t1 = 345.634;

  int i = 0;
  for (i = 0; i < N; i++) {
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    t1 = asinh(t1);
    ;
  }
  *result_asinh = t1;
}