//{"elem_size":4,"incx":1,"incy":3,"x":0,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void swap_interleave_naive(global char* x, unsigned int incx, global char* y, unsigned int incy, int elem_size) {
  unsigned int gid = get_global_id(0);
  for (unsigned int i = 0; i < elem_size; i++) {
    char this_x = x[hook(0, gid * incx + i)];
    char this_y = y[hook(2, gid * incy + i)];
    x[hook(0, gid * incx + i)] = this_y;
    y[hook(2, gid * incy + i)] = this_x;
  }
}