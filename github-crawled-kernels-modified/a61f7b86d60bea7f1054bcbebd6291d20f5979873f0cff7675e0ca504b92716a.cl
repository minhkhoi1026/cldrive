//{"Gx_global":5,"Gy_global":6,"center_x":1,"center_y":2,"field_num":0,"nx":8,"ny":9,"prefactor":3,"radial_scaling":4,"rho_global":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_radial_g_force(const int field_num, const int center_x, const int center_y, const double prefactor, const double radial_scaling, global double* Gx_global, global double* Gy_global, global double* rho_global, const int nx, const int ny) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if ((x < nx) && (y < ny)) {
    int three_d_index = field_num * nx * ny + y * nx + x;

    double rho = rho_global[hook(7, three_d_index)];

    const double dx = x - center_x;
    const double dy = y - center_y;

    const double radius_dim = sqrt(dx * dx + dy * dy);
    const double theta = atan2(dy, dx);

    const double rhat_x = cos(theta);
    const double rhat_y = sin(theta);

    double magnitude = prefactor * ((double)pow(radius_dim, radial_scaling));
    Gx_global[hook(5, three_d_index)] += rho * magnitude * rhat_x;
    Gy_global[hook(6, three_d_index)] += rho * magnitude * rhat_y;
  }
}