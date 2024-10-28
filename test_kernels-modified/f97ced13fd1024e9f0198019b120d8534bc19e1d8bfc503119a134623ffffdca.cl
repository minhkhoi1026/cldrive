//{"a":1,"incx":3,"incy":5,"n":0,"x":2,"y":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void saxpy_gpu(int n, float a, global float* x, int incx, global float* y, int incy) {
  size_t i = get_global_id(0);
  if (i < n) {
    y[hook(4, i * incy)] += a * x[hook(2, i * incx)];
  }
}