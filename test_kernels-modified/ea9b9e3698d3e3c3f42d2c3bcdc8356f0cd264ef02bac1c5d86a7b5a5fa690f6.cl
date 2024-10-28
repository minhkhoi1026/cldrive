//{"c":5,"incx":2,"incy":4,"n":0,"s":6,"x":1,"y":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Srot_naive(unsigned int n, global float* x, int incx, global float* y, int incy, float c, float s) {
  for (unsigned int i = 0; i < n; i++) {
    unsigned int idx = i * incx;
    unsigned int idy = i * incy;

    float current_x = x[hook(1, idx)];
    float current_y = y[hook(3, idy)];

    float sy = s * current_y;
    float cy = c * current_y;

    float _x = fma(c, current_x, sy);
    y[hook(3, idy)] = fma(-s, current_x, cy);

    x[hook(1, idx)] = _x;
  }
}