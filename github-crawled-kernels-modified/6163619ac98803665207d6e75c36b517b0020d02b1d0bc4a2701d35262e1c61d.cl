//{"M":2,"N":3,"dx":0,"dy":1,"psi":4,"u":5,"v":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sw_init_velocities(const double dx, const double dy, const unsigned M, const unsigned N, global const double* psi, global double* u, global double* v) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < N && y < M) {
    u[hook(5, (y + 1) * M + x)] = -(psi[hook(4, (y + 1) * M + x + 1)] - psi[hook(4, (y + 1) * M + x)]) / dy;
    v[hook(6, y * M + x + 1)] = (psi[hook(4, (y + 1) * M + x + 1)] - psi[hook(4, y * M + x + 1)]) / dx;
  }
}