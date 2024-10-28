//{"incx":3,"incy":6,"n":0,"x":1,"x_offset":2,"y":4,"y_offset":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sswap_kernel(int n, global float* x, unsigned long x_offset, int incx, global float* y, unsigned long y_offset, int incy) {
  x += x_offset;
  y += y_offset;

  float tmp;
  int ind = get_local_id(0) + get_local_size(0) * get_group_id(0);
  if (ind < n) {
    x += ind * incx;
    y += ind * incy;
    tmp = *x;
    *x = *y;
    *y = tmp;
  }
}