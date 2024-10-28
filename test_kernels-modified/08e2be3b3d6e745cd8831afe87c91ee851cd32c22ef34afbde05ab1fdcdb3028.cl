//{"c":3,"incy":2,"s":4,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Srot_noincx(global float* x, global float* y, int incy, float c, float s) {
  int gid = get_global_id(0);

  int idy = gid * incy;

  float current_x = x[hook(0, gid)];
  float current_y = y[hook(1, idy)];

  float sy = s * current_y;
  float _x = fma(c, current_x, sy);

  float cy = c * current_y;
  y[hook(1, idy)] = fma(-s, current_x, cy);

  x[hook(0, gid)] = _x;
}