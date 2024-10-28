//{"N":1,"result_asinh":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_asinh_withDD4(global float* result_asinh, int N) {
  float t1 = 345.634;
  float4 t2 = t1 + (float4)(0);
  int i = 0;
  for (i = 0; i < N; i++) {
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    t2 = asinh(t2);
    ;
  }
  *result_asinh = t2.s0 + t2.s1 + t2.s2 + t2.s3;
}