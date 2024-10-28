//{"a":1,"incx":3,"incy":5,"n":0,"x":2,"y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void daxpy_gpu(int n, double a, global double* x, int incx, global double* y, int incy) {
  size_t i = get_global_id(0);
  if (i < n) {
    y[hook(4, i * incy)] += a * x[hook(2, i * incx)];
  }
}