//{"a":5,"diag":2,"incx":8,"k":4,"lda":6,"n":3,"trans":1,"uplo":0,"x":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float access(const global float* a, int m, int n, int N) {
  return a[hook(5, n * N + m)];
}

kernel void Stbsv_naive(const int uplo, const int trans, const int diag, const int n, const int k, const global float* a, const int lda, global float* x, const int incx) {
  bool ltriangle = uplo == 1;
  bool ntrans = trans == 0;
  bool unitd = diag == 1;

  if (ntrans) {
    if (ltriangle) {
      for (int i = 0; i < n; i++) {
        if (!unitd) {
          x[hook(7, i * incx)] = x[hook(7, i * incx)] / access(a, 0, i, lda);
        }
        for (int j = 1; j < min(k + 1, n - i); j++) {
          x[hook(7, (i + j) * incx)] -= x[hook(7, i * incx)] * access(a, j, i, lda);
        }
      }
    } else {
      for (int i = n - 1; i >= 0; i--) {
        if (!unitd) {
          x[hook(7, i * incx)] = x[hook(7, i * incx)] / access(a, k, i, lda);
        }
        for (int j = 1; j < min(k + 1, i + 1); j++) {
          x[hook(7, (i - j) * incx)] -= x[hook(7, i * incx)] * access(a, k - j, i, lda);
        }
      }
    }
  } else {
    if (ltriangle) {
      for (int i = n - 1; i >= 0; i--) {
        if (!unitd) {
          x[hook(7, i * incx)] = x[hook(7, i * incx)] / access(a, 0, i, lda);
        }
        for (int j = 1; j < min(k + 1, i + 1); j++) {
          x[hook(7, (i - j) * incx)] -= x[hook(7, i * incx)] * access(a, j, i - j, lda);
        }
      }
    } else {
      for (int i = 0; i < n; i++) {
        if (!unitd) {
          x[hook(7, i * incx)] = x[hook(7, i * incx)] / access(a, k, i, lda);
        }
        for (int j = 1; j < min(k + 1, n - i); j++) {
          x[hook(7, (i + j) * incx)] -= x[hook(7, i * incx)] * access(a, k - j, i + j, lda);
        }
      }
    }
  }
}