//{"cu":5,"cv":6,"fsdx":0,"fsdy":1,"h":8,"p":4,"u":2,"v":3,"z":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void l100(double fsdx, double fsdy, global double* u, global double* v, global double* p, global double* cu, global double* cv, global double* z, global double* h) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < 64 && y < 64) {
    cu[hook(5, (y + 1) * (64 + 1) + (x))] = .5 * (p[hook(4, (y + 1) * (64 + 1) + (x))] + p[hook(4, (y) * (64 + 1) + (x))]) * u[hook(2, (y + 1) * (64 + 1) + (x))];
    cv[hook(6, (y) * (64 + 1) + (x + 1))] = .5 * (p[hook(4, (y) * (64 + 1) + (x + 1))] + p[hook(4, (y) * (64 + 1) + (x))]) * v[hook(3, (y) * (64 + 1) + (x + 1))];
    z[hook(7, (y + 1) * (64 + 1) + (x + 1))] = (fsdx * (v[hook(3, (y + 1) * (64 + 1) + (x + 1))] - v[hook(3, (y) * (64 + 1) + (x + 1))]) - fsdy * (u[hook(2, (y + 1) * (64 + 1) + (x + 1))] - u[hook(2, (y + 1) * (64 + 1) + (x))])) / (p[hook(4, (y) * (64 + 1) + (x))] + p[hook(4, (y + 1) * (64 + 1) + (x))] + p[hook(4, (y + 1) * (64 + 1) + (x + 1))] + p[hook(4, (y) * (64 + 1) + (x + 1))]);
    h[hook(8, (y) * (64 + 1) + (x))] = p[hook(4, (y) * (64 + 1) + (x))] + .25 * (u[hook(2, (y + 1) * (64 + 1) + (x))] * u[hook(2, (y + 1) * (64 + 1) + (x))] + u[hook(2, (y) * (64 + 1) + (x))] * u[hook(2, (y) * (64 + 1) + (x))] + v[hook(3, (y) * (64 + 1) + (x + 1))] * v[hook(3, (y) * (64 + 1) + (x + 1))] + v[hook(3, (y) * (64 + 1) + (x))] * v[hook(3, (y) * (64 + 1) + (x))]);
  }
}