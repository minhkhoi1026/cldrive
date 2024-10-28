//{"AP":4,"diag":2,"incx":6,"n":3,"parties":7,"trans":1,"uplo":0,"x":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Stpmv_naive(int uplo, int trans, int diag, int n, global float* AP, global float* x, int incx, global float* parties) {
  bool isUp = (uplo == 0);
  bool isDiag = (diag == 1);
  bool isNTrans = (trans == 0);

  if (isUp && isNTrans) {
    int kk = 0;

    for (int i = 0; i < n; i++) {
      int k = kk + i + 1;

      parties[hook(7, i)] = isDiag ? x[hook(5, i * incx)] : x[hook(5, i * incx)] * AP[hook(4, kk)];

      for (int j = i + 1; j < n; j++, k += j) {
        parties[hook(7, i)] += x[hook(5, j * incx)] * AP[hook(4, k)];
      }

      kk += (i + 2);
    }
  }

  if (isUp && !isNTrans) {
    int k = 0;

    for (int i = 0; i < n; i++) {
      for (int j = 0; j < i; j++, k++) {
        parties[hook(7, i)] += x[hook(5, j * incx)] * AP[hook(4, k)];
      }

      parties[hook(7, i)] += isDiag ? x[hook(5, i * incx)] : x[hook(5, i * incx)] * AP[hook(4, k)];

      k += 1;
    }
  }

  if (!isUp && isNTrans) {
    int kk = 0;

    for (int i = 0; i < n; i++) {
      int k = kk;

      for (int j = 0; j < i; j++, k += (n - j)) {
        parties[hook(7, i)] += x[hook(5, j * incx)] * AP[hook(4, k)];
      }

      parties[hook(7, i)] += isDiag ? x[hook(5, i * incx)] : x[hook(5, i * incx)] * AP[hook(4, k)];

      kk += 1;
    }
  }

  if (!isUp && !isNTrans) {
    int k = 0;

    for (int i = 0; i < n; i++) {
      parties[hook(7, i)] = isDiag ? x[hook(5, i * incx)] : x[hook(5, i * incx)] * AP[hook(4, k)];

      k += 1;

      for (int j = i + 1; j < n; j++, k++) {
        parties[hook(7, i)] += x[hook(5, j * incx)] * AP[hook(4, k)];
      }
    }
  }

  for (int i = 0; i < n; i++) {
    x[hook(5, i * incx)] = parties[hook(7, i)];
  }
}