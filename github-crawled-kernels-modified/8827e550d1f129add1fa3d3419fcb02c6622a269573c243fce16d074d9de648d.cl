//{"N":1,"result_ceil":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_ceil_withDD1(global float* result_ceil, int N) {
  float p1 = -0.25;
  int i = 0;
  for (i = 0; i < N; i = i + 1) {
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    p1 += ceil(p1);
    ;
  }
  *result_ceil = p1;
}