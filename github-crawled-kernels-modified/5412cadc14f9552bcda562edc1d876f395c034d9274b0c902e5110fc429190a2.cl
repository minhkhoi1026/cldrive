//{"N":1,"result_asinh":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_asinh_withoutDD1(global float* result_asinh, int N) {
  float t1 = 1.0;
  float t2 = 1.0;
  float t3 = 1.0;
  float t4 = 1.0;
  float t5 = 1.0;
  float t6 = 1.0;
  float t7 = 1.0;
  float t8 = 1.0;
  float t9 = 1.0;
  float t10 = 1.0;

  float i = 0.0;
  float n = (float)(N);

  for (i = 0.0; i < n; i = i + 0.1) {
    t1 = asinh(i);
    t2 = asinh(i);
    t3 = asinh(i);
    t4 = asinh(i);
    t5 = asinh(i);
    t6 = asinh(i);
    t7 = asinh(i);
    t8 = asinh(i);
    t9 = asinh(i);
    t10 = asinh(i);
  }
  *result_asinh = t1 + t2 + t3 + t4 + t5 + t6 + t7 + t8 + t9 + t10;
}