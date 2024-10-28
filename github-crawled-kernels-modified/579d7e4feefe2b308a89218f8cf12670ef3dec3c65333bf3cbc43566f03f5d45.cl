//{"M_LEN":2,"cu":6,"cv":7,"fsdx":0,"fsdy":1,"h":9,"p":5,"u":3,"v":4,"z":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sw_compute0(const double fsdx, const double fsdy, const unsigned M_LEN, global const double* u, global const double* v, global const double* p, global double* cu, global double* cv, global double* z, global double* h) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  cu[hook(6, (y + 1) * M_LEN + x)] = 0.5 * (p[hook(5, (y + 1) * M_LEN + x)] + p[hook(5, y * M_LEN + x)]) * u[hook(3, (y + 1) * M_LEN + x)];
  cv[hook(7, y * M_LEN + x + 1)] = 0.5 * (p[hook(5, y * M_LEN + x + 1)] + p[hook(5, y * M_LEN + x)]) * v[hook(4, y * M_LEN + x + 1)];
  z[hook(8, (y + 1) * M_LEN + x + 1)] = (fsdx * (v[hook(4, (y + 1) * M_LEN + x + 1)] - v[hook(4, y * M_LEN + x + 1)]) - fsdy * (u[hook(3, (y + 1) * M_LEN + x + 1)] - u[hook(3, (y + 1) * M_LEN + x)])) / (p[hook(5, y * M_LEN + x)] + p[hook(5, (y + 1) * M_LEN + x)] + p[hook(5, (y + 1) * M_LEN + x + 1)] + p[hook(5, y * M_LEN + x + 1)]);
  h[hook(9, y * M_LEN + x)] = p[hook(5, y * M_LEN + x)] + 0.25 * (u[hook(3, (y + 1) * M_LEN + x)] * u[hook(3, (y + 1) * M_LEN + x)] + u[hook(3, y * M_LEN + x)] * u[hook(3, y * M_LEN + x)] + v[hook(4, y * M_LEN + x + 1)] * v[hook(4, y * M_LEN + x + 1)] + v[hook(4, y * M_LEN + x)] * v[hook(4, y * M_LEN + x)]);
}