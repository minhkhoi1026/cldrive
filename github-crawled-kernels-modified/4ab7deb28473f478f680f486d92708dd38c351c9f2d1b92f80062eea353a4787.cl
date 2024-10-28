//{"A":6,"alpha":1,"incx":3,"incy":5,"lda":7,"n":0,"x":2,"y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Ssyr2_opt_async_upper(unsigned int n, float alpha, const constant float* x, int incx, const constant float* y, int incy, global float* A, unsigned int lda) {
  int row_id = get_global_id(0);
  int col_id = get_global_id(1);

  if (row_id <= col_id) {
    float rank_delta = fma(x[hook(2, row_id * incx)], y[hook(4, col_id * incy)], y[hook(4, row_id * incy)] * x[hook(2, col_id * incx)]);
    A[hook(6, col_id * lda + row_id)] = fma(alpha, rank_delta, A[hook(6, col_id * lda + row_id)]);
  }
}