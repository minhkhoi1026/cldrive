//{"incx":1,"incy":3,"x":0,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void swap_interleave_dwords(global unsigned int* x, unsigned int incx, global unsigned int* y, unsigned int incy) {
  unsigned int gid = get_global_id(0);
  unsigned int this_x = x[hook(0, gid * incx)];
  unsigned int this_y = y[hook(2, gid * incy)];
  x[hook(0, gid * incx)] = this_y;
  y[hook(2, gid * incy)] = this_x;
}