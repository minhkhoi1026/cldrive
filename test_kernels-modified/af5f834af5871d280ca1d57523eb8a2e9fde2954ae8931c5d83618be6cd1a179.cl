//{"incx":1,"incy":3,"x":0,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void swap_interleave_qwords(global uint2* x, int incx, global uint2* y, int incy) {
  unsigned int gid = get_global_id(0);
  uint2 this_x = x[hook(0, gid * incx)];
  uint2 this_y = y[hook(2, gid * incy)];
  y[hook(2, gid * incy)] = this_x;
  x[hook(0, gid * incx)] = this_y;
}