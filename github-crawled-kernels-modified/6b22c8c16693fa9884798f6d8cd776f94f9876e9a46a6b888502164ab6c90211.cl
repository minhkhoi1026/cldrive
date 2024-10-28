//{"a":4,"diag":2,"incx":7,"lda":5,"n":3,"trans":1,"uplo":0,"x":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float access(const global float* a, int m, int n, int N) {
  return a[hook(4, n * N + m)];
}

kernel void Strsv_naive(const int uplo, const int trans, const int diag, const int n, const global float* a, const int lda, global float* x, const int incx) {
  bool ntrans = trans == 0;
  bool ltriangle = uplo == 1;
  bool ndiag = diag == 0;

  if (ntrans) {
    if (ltriangle) {
      for (int i = 0; i < n; i++) {
        if (ndiag) {
          x[hook(6, i * incx)] = x[hook(6, i * incx)] / access(a, i, i, lda);
        }
        float temp = x[hook(6, i * incx)];
        for (int j = i + 1; j < n; j++) {
          x[hook(6, j * incx)] -= temp * access(a, j, i, lda);
        }
      }
    } else {
      for (int i = n - 1; i >= 0; i--) {
        if (ndiag) {
          x[hook(6, i * incx)] = x[hook(6, i * incx)] / access(a, i, i, lda);
        }
        float temp = x[hook(6, i * incx)];
        for (int j = i - 1; j >= 0; j--) {
          x[hook(6, j * incx)] -= temp * access(a, j, i, lda);
        }
      }
    }
  } else {
    if (ltriangle) {
      for (int i = n - 1; i >= 0; i--) {
        if (ndiag) {
          x[hook(6, i * incx)] = x[hook(6, i * incx)] / access(a, i, i, lda);
        }
        float temp = x[hook(6, i * incx)];
        for (int j = i - 1; j >= 0; j--) {
          x[hook(6, j * incx)] -= temp * access(a, i, j, lda);
        }
      }
    } else {
      for (int i = 0; i < n; i++) {
        if (ndiag) {
          x[hook(6, i * incx)] = x[hook(6, i * incx)] / access(a, i, i, lda);
        }
        float temp = x[hook(6, i * incx)];
        for (int j = i + 1; j < n; j++) {
          x[hook(6, j * incx)] -= temp * access(a, i, j, lda);
        }
      }
    }
  }
}