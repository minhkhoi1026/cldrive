//{"alpha":0,"incx":2,"incy":4,"x":1,"y":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Saxpy_naive(float alpha, global float* x, unsigned int incx, global float* y, unsigned int incy) {
  unsigned int gid = get_global_id(0);
  y[hook(3, gid * incy)] += alpha * x[hook(1, gid * incx)];
}