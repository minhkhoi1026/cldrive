//{"A":0,"B":1,"C":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MatrixMultiplication(global float const* restrict A, global float const* restrict B, global float* restrict C) {
  for (int n = 0; n < 32; ++n) {
    for (int m = 0; m < 32; ++m) {
      float acc = 0;
      for (int k = 0; k < 32; ++k) {
        acc += A[hook(0, n * 32 + k)] * B[hook(1, k * 32 + m)];
      }
      C[hook(2, n * 32 + m)] = acc;
    }
  }
}