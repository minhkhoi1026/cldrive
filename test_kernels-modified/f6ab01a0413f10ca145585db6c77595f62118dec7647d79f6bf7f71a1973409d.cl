//{"A":4,"alpha":3,"beta":8,"incx":7,"incy":10,"lda":5,"m":1,"n":2,"trans":0,"x":6,"y":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Sgemv_naive_async(int trans, int m, int n, float alpha, global float* A, int lda, global float* x, int incx, float beta, global float* y, int incy) {
  unsigned int row_id = get_global_id(0);

  if (trans == (0)) {
    float l_result = 0;
    for (unsigned int col_id = 0; col_id < n; ++col_id) {
      l_result = mad(alpha * A[hook(4, col_id * lda + row_id)], x[hook(6, col_id * incx)], l_result);
    }

    if (beta != 0)
      y[hook(9, row_id * incy)] = l_result + beta * y[hook(9, row_id * incy)];
    else
      y[hook(9, row_id * incy)] = l_result;
  }

  if (trans == (1) | trans == (2)) {
    float l_result = 0;
    for (unsigned int col_id = 0; col_id < m; ++col_id) {
      l_result = mad(alpha * A[hook(4, row_id * lda + col_id)], x[hook(6, col_id * incx)], l_result);
    }

    if (beta != 0)
      y[hook(9, row_id * incy)] = l_result + beta * y[hook(9, row_id * incy)];
    else
      y[hook(9, row_id * incy)] = l_result;
  }
}