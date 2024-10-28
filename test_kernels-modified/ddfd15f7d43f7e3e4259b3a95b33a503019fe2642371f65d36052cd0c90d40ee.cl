//{"A":4,"a":11,"alpha":3,"beta":8,"incx":7,"incy":10,"k":2,"lda":5,"n":1,"uplo":0,"x":6,"y":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float access(const global float* a, int m, int n, int N) {
  return a[hook(11, m * N + n)];
}

kernel void Ssbmv_naive(int uplo, int n, int k, float alpha, global float* A, int lda, global float* x, int incx, float beta, global float* y, int incy) {
  bool isUp = (uplo == 0);

  if (isUp) {
    for (int i = 0; i < n; i++) {
      float value = x[hook(6, i * incx)] * access(A, i, k, lda);

      for (int j = 1; j < min(n - i, k + 1); j++) {
        value += x[hook(6, (i + j) * incx)] * access(A, i + j, k - j, lda);
      }

      for (int j = 1; j < min(i + 1, k + 1); j++) {
        value += x[hook(6, (i - j) * incx)] * access(A, i, 0, lda);
      }

      y[hook(9, i * incy)] = alpha * value + beta * y[hook(9, i * incy)];
    }
  }

  if (!isUp) {
    for (int i = 0; i < n; i++) {
      float value = x[hook(6, i * incx)] * access(A, i, 0, lda);

      for (int j = 1; j < min(k + 1, n - i); j++) {
        value += x[hook(6, (i + j) * incx)] * access(A, i, j, lda);
      }

      for (int j = 1; j < min(i + 1, k + 1); j++) {
        value += x[hook(6, (i - j) * incx)] * access(A, i, -1 * j, lda);
      }

      y[hook(9, i * incy)] = alpha * value + beta * y[hook(9, i * incy)];
    }
  }
}