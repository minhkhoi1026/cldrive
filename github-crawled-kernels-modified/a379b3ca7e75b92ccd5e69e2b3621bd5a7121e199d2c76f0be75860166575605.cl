//{"N":1,"result_rsqrt":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_rsqrt_withDD4(global float* result_rsqrt, int N) {
  float t1 = 23456.234;
  float4 t2 = t1 + (float4)(0);
  int i = 0;
  for (i = 0; i < N; i++) {
    t2 = rsqrt(t2);
    t2 = rsqrt(t2);
    t2 = rsqrt(t2);
    t2 = rsqrt(t2);
    t2 = rsqrt(t2);
    t2 = rsqrt(t2);
    t2 = rsqrt(t2);
    t2 = rsqrt(t2);
    t2 = rsqrt(t2);
    t2 = rsqrt(t2);
    t2 = rsqrt(t2);
    t2 = rsqrt(t2);
    t2 = rsqrt(t2);
    t2 = rsqrt(t2);
    t2 = rsqrt(t2);
    t2 = rsqrt(t2);
    ;
  }
  *result_rsqrt = t2.s0 + t2.s1 + t2.s2 + t2.s3;
}