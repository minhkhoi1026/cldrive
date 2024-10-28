//{"alpha":0,"incx":2,"x":1,"y":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Saxpy_noincy(float alpha, global float* x, unsigned int incx, global float* y) {
  unsigned int gid = get_global_id(0);
  float this_x = x[hook(1, gid * incx)];
  float this_y = y[hook(3, gid)];
  this_y += alpha * this_x;
  y[hook(3, gid)] = this_y;
}