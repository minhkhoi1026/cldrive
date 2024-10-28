//{"Lx":4,"Ly":5,"Nx":2,"Ny":3,"u":0,"v":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void initialdata(global double2* u, global double2* v, const int Nx, const int Ny, const double Lx, const double Ly) {
  const int ind = get_global_id(0);
  int i, j;
  j = floor((double)(ind) / (double)Nx);
  i = ind - j * Nx;
  double x = (-1.0 + (2.0 * (double)i / (double)Nx)) * 3.14159265358979323846f * Lx;
  double y = (-1.0 + (2.0 * (double)j / (double)Ny)) * 3.14159265358979323846f * Ly;
  u[hook(0, ind)].x = 0.5 + exp(-1.0 * (x * x + y * y) - 1.0);
  u[hook(0, ind)].y = 0.0;
  v[hook(1, ind)].x = 0.1 + exp(-1.0 * (x * x + y * y) - 1.0);
  v[hook(1, ind)].y = 0.0;
}