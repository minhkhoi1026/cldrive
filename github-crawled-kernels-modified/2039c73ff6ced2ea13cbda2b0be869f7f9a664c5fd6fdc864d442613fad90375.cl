//{"c":3,"incx":1,"s":4,"x":0,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Srot_noincy(global float* x, int incx, global float* y, float c, float s) {
  int gid = get_global_id(0);

  int idx = gid * incx;

  float current_x = x[hook(0, idx)];
  float current_y = y[hook(2, gid)];

  float sy = s * current_y;
  float _x = fma(c, current_x, sy);

  float cy = c * current_y;
  y[hook(2, gid)] = fma(-s, current_x, cy);

  x[hook(0, idx)] = _x;
}