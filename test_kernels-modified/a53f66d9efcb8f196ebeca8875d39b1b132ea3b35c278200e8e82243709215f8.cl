//{"A":2,"alpha":1,"beta":6,"incx":5,"incy":8,"lda":3,"n":0,"x":4,"y":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Ssymv_naive_upper(unsigned int n, float alpha, global float* A, unsigned int lda, global float* x, int incx, float beta, global float* y, int incy) {
  for (unsigned int i = 0; i < n; ++i) {
    float result = 0;
    for (unsigned int j = 0; j < n; ++j) {
      if (j >= i)
        result = fma(A[hook(2, j * lda + i)], x[hook(4, j * incx)], result);
      else
        result = fma(A[hook(2, i * lda + j)], x[hook(4, j * incx)], result);
    }

    if (beta != 0)
      y[hook(7, i * incy)] = fma(alpha, result, beta * y[hook(7, i * incy)]);
    else
      y[hook(7, i * incy)] = alpha * result;
  }
}