//{"a":5,"alpha":2,"incx":4,"lda":6,"n":1,"uplo":0,"x":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Ssyr_naive(int uplo, unsigned int n, float alpha, global float* x, unsigned int incx, global float* a, unsigned int lda) {
  bool ltriangle = uplo == (1);

  if (ltriangle) {
    for (unsigned int col = 0; col < n; col++) {
      float prod = alpha * x[hook(3, col * incx)];
      for (unsigned int row = col; row < n; row++) {
        a[hook(5, col * lda + row)] += prod * x[hook(3, row * incx)];
      }
    }
  } else {
    for (unsigned int col = 0; col < n; col++) {
      float prod = alpha * x[hook(3, col * incx)];
      for (unsigned int row = 0; row <= col; row++) {
        a[hook(5, col * lda + row)] += prod * x[hook(3, row * incx)];
      }
    }
  }
}