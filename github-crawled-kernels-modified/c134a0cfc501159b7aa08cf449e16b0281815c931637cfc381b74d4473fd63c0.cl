//{"N":1,"result_fma":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_fma_withDD1(global float* result_fma, int N) {
  float p1 = 1.0;
  float p2 = 2.2;
  float p3 = -34245.23;

  int i = 0;
  for (i = 0; i < N; i++) {
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    p3 = fma(p1, p2, p3);
    ;
  }
  *result_fma = p3;
}