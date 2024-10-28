//{"A":5,"a":9,"diag":2,"incx":8,"k":4,"lda":6,"n":3,"trans":1,"uplo":0,"x":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float access(const global float* a, int m, int n, int N) {
  return a[hook(9, n * N + m)];
}

kernel void Stbmv_naive(int uplo, int trans, int diag, int n, int k, global float* A, int lda, global float* x, int incx) {
  bool isUp = (uplo == 0);
  bool isDiag = (diag == 1);
  bool isNTrans = (trans == 0);

  if (isUp && isNTrans) {
    for (int i = 0; i < n; i++) {
      x[hook(7, i * incx)] = isDiag ? x[hook(7, i * incx)] : x[hook(7, i * incx)] * access(A, k, i, lda);

      for (int j = 1; j < min(n - i, k + 1); j++) {
        x[hook(7, i * incx)] += x[hook(7, (i + j) * incx)] * access(A, k - j, i + j, lda);
      }
    }
  }

  if (isUp && !isNTrans) {
    for (int i = n - 1; i >= 0; i--) {
      x[hook(7, i * incx)] = isDiag ? x[hook(7, i * incx)] : x[hook(7, i * incx)] * access(A, k, i, lda);

      for (int j = 1; j < min(i + 1, k + 1); j++) {
        x[hook(7, i * incx)] += x[hook(7, (i - j) * incx)] * access(A, k - j, i, lda);
      }
    }
  }

  if (!isUp && isNTrans) {
    for (int i = n - 1; i >= 0; i--) {
      x[hook(7, i * incx)] = isDiag ? x[hook(7, i * incx)] : x[hook(7, i * incx)] * access(A, 0, i, lda);

      for (int j = 1; j < min(i + 1, k + 1); j++) {
        x[hook(7, i * incx)] += x[hook(7, (i - j) * incx)] * access(A, j, i - j, lda);
      }
    }
  }

  if (!isUp && !isNTrans) {
    for (int i = 0; i < n; i++) {
      x[hook(7, i * incx)] = isDiag ? x[hook(7, i * incx)] : x[hook(7, i * incx)] * access(A, 0, i, lda);

      for (int j = 1; j < min(k + 1, n - i); j++) {
        x[hook(7, i * incx)] += x[hook(7, j * incx)] * access(A, j, i, lda);
      }
    }
  }
}