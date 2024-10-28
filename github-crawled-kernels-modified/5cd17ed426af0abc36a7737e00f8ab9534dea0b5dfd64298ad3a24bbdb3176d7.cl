//{"Gx_global":3,"Gy_global":4,"field_num":0,"g_x":1,"g_y":2,"nx":6,"ny":7,"rho_global":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_constant_g_force(const int field_num, const double g_x, const double g_y, global double* Gx_global, global double* Gy_global, global double* rho_global, const int nx, const int ny) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if ((x < nx) && (y < ny)) {
    int three_d_index = field_num * nx * ny + y * nx + x;

    double rho = rho_global[hook(5, three_d_index)];

    Gx_global[hook(3, three_d_index)] += g_x * rho;
    Gy_global[hook(4, three_d_index)] += g_y * rho;
  }
}