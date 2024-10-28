//{"dx":0,"dy":1,"psi":4,"u":2,"v":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void init2(double dx, double dy, global double* u, global double* v, global double* psi) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < 64 && y < 64) {
    u[hook(2, (y + 1) * (64 + 1) + x)] = -(psi[hook(4, (y + 1) * (64 + 1) + x + 1)] - psi[hook(4, (y + 1) * (64 + 1) + x)]) / dy;
    v[hook(3, y * (64 + 1) + x + 1)] = (psi[hook(4, (y + 1) * (64 + 1) + x + 1)] - psi[hook(4, y * (64 + 1) + x + 1)]) / dx;
  }
}