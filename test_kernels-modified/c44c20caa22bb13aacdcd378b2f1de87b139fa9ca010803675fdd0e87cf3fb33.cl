//{"A":5,"diag":2,"incx":7,"lda":4,"n":3,"trans":1,"uplo":0,"x":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Strmv_naive(int uplo, int trans, int diag, int n, int lda, global float* A, global float* x, int incx) {
  bool isUp = (uplo == 0);
  bool isDiag = (diag == 1);
  bool isNTrans = (trans == 0);

  if (isUp && isNTrans) {
    for (int row = 0; row < n; row++) {
      x[hook(6, row * incx)] = isDiag ? x[hook(6, row * incx)] : A[hook(5, (row) * (lda) + (row))] * x[hook(6, row * incx)];

      for (int column = row + 1; column < n; column++) {
        x[hook(6, row * incx)] += A[hook(5, (column) * (lda) + (row))] * x[hook(6, column * incx)];
      }
    }
  }

  if (isUp && !isNTrans) {
    for (int row = n - 1; row >= 0; row--) {
      x[hook(6, row * incx)] = isDiag ? x[hook(6, row * incx)] : A[hook(5, (row) * (lda) + (row))] * x[hook(6, row * incx)];

      for (int column = 0; column < row; column++) {
        x[hook(6, row * incx)] += A[hook(5, (row) * (lda) + (column))] * x[hook(6, column * incx)];
      }
    }
  }

  if (!isUp && isNTrans) {
    for (int row = n - 1; row >= 0; row--) {
      x[hook(6, row * incx)] = isDiag ? x[hook(6, row * incx)] : A[hook(5, (row) * (lda) + (row))] * x[hook(6, row * incx)];

      for (int column = 0; column < row; column++) {
        x[hook(6, row * incx)] += A[hook(5, (column) * (lda) + (row))] * x[hook(6, column * incx)];
      }
    }
  }

  if (!isUp && !isNTrans) {
    for (int row = 0; row < n; row++) {
      x[hook(6, row * incx)] = isDiag ? x[hook(6, row * incx)] : A[hook(5, (row) * (lda) + (row))] * x[hook(6, row * incx)];

      for (int column = row + 1; column < n; column++) {
        x[hook(6, row * incx)] += A[hook(5, (row) * (lda) + (column))] * x[hook(6, column * incx)];
      }
    }
  }
}