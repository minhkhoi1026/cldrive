//{"AP":3,"alpha":2,"beta":6,"incx":5,"incy":8,"n":1,"uplo":0,"x":4,"y":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Sspmv_naive(int uplo, int n, float alpha, global float* AP, global float* x, int incx, float beta, global float* y, int incy) {
  bool isUp = (uplo == 0);

  if (isUp) {
    int kk1 = 0;
    int kk2 = 0;

    for (int i = 0; i < n; i++) {
      int k1 = kk1;
      int k2 = kk2;
      float value = 0.f;

      for (int j = i; j < n; j++, k1 += j) {
        value += AP[hook(3, k1)] * x[hook(4, j * incx)];
      }

      for (int j = 0; j < i; j++, k2++) {
        value += AP[hook(3, k2)] * x[hook(4, j * incx)];
      }

      y[hook(7, i * incy)] = alpha * value + beta * y[hook(7, i * incy)];

      kk1 += (i + 2);
      kk2 += (i + 1);
    }
  }

  if (!isUp) {
    int kk1 = 0;
    int kk2 = 0;

    for (int i = 0; i < n; i++) {
      int k1 = kk1;
      int k2 = kk2;
      float value = 0.f;

      for (int j = i; j < n; j++, k1++) {
        value += AP[hook(3, k1)] * x[hook(4, j * incx)];
      }

      for (int j = 0; j < i; j++, k2 += (n - j)) {
        value += AP[hook(3, k2)] * x[hook(4, j * incx)];
      }

      y[hook(7, i * incy)] = alpha * value + beta * y[hook(7, i * incy)];

      kk1 += (n - i);
      kk2 += 1;
    }
  }
}