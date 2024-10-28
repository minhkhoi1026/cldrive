//{"c":4,"incx":1,"incy":3,"s":5,"x":0,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Srot_async(global float* x, int incx, global float* y, int incy, float c, float s) {
  unsigned int gid = get_global_id(0);

  unsigned int idx = gid * incx;
  unsigned int idy = gid * incy;

  float current_x = x[hook(0, idx)];
  float current_y = y[hook(2, idy)];

  float sy = s * current_y;
  float _x = fma(c, current_x, sy);

  float cy = c * current_y;
  y[hook(2, idy)] = fma(-s, current_x, cy);

  x[hook(0, idx)] = _x;
}