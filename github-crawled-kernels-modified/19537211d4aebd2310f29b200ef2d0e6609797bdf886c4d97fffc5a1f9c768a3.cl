//{"A":1,"B":4,"X":7,"n":10,"offA":3,"offB":6,"offX":9,"strideA":2,"strideB":5,"strideX":8,"valid":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void floatMatrixTrsm(const unsigned int valid, global float* A, const unsigned int strideA, const unsigned int offA, global float* B, const unsigned int strideB, const unsigned int offB, global float* X, const unsigned int strideX, const unsigned int offX, const unsigned int n) {
  int gy = get_global_id(1);

  if (gy >= valid)
    return;

  for (long i = n - 1; i >= 0; i--) {
    float aval = A[hook(1, offA + gy * strideA + i)];
    for (long j = i + 1; j < n; j++) {
      aval -= B[hook(4, offB + j * strideB + i)] * X[hook(7, offX + gy * strideX + j)];
    }
    aval /= B[hook(4, offB + i * strideB + i)];
    X[hook(7, offX + gy * strideX + i)] = aval;
  }
}