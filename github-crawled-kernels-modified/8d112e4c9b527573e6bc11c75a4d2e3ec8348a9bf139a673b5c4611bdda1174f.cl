//{"ap":4,"diag":2,"incx":6,"n":3,"trans":1,"uplo":0,"x":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Stpsv_naive(const int uplo, const int trans, const int diag, int n, global float* ap, global float* x, int incx) {
  bool ntrans = trans == 0;
  bool ltriangle = uplo == 1;
  bool ndiag = diag == 0;

  if (ntrans) {
    if (ltriangle) {
      unsigned int starting = 0;
      for (int i = 0; i < n; i++) {
        if (ndiag) {
          x[hook(5, i * incx)] = x[hook(5, i * incx)] / ap[hook(4, starting)];
        }
        float temp = x[hook(5, i * incx)];
        for (int j = 1; j < n - i; j++) {
          x[hook(5, (i + j) * incx)] -= temp * ap[hook(4, starting + j)];
        }
        starting += n - i;
      }
    } else {
      unsigned int starting = n * (n + 1) / 2 - 1;
      for (int i = n - 1; i >= 0; i--) {
        if (ndiag) {
          x[hook(5, i * incx)] = x[hook(5, i * incx)] / ap[hook(4, starting)];
        }
        float temp = x[hook(5, i * incx)];
        for (int j = 1; j < i + 1; j++) {
          x[hook(5, (i - j) * incx)] -= temp * ap[hook(4, starting - j)];
        }
        starting -= i + 1;
      }
    }
  } else {
    if (ltriangle) {
      unsigned int starting = n * (n + 1) / 2 - 1;
      for (int i = n - 1; i >= 0; i--) {
        if (ndiag) {
          x[hook(5, i * incx)] = x[hook(5, i * incx)] / ap[hook(4, starting)];
        }
        float temp = x[hook(5, i * incx)];
        for (int j = 1; j < i + 1; j++) {
          x[hook(5, (i - j) * incx)] -= temp * ap[hook(4, starting - (n - i - 1) * j - j * (j + 1) / 2)];
        }
        starting -= n - i + 1;
      }
    } else {
      unsigned int starting = 0;
      for (int i = 0; i < n; i++) {
        if (ndiag) {
          x[hook(5, i * incx)] = x[hook(5, i * incx)] / ap[hook(4, starting)];
        }
        float temp = x[hook(5, i * incx)];
        for (int j = 1; j < n - i; j++) {
          x[hook(5, (i + j) * incx)] -= temp * ap[hook(4, starting + i * j + j * (j + 1) / 2)];
        }
        starting += i + 2;
      }
    }
  }
}