//{"f_global":0,"nx":4,"ny":5,"u_e":3,"u_global":1,"u_w":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void move_bcs_PeriodicBC_VelocityInlet(global float* f_global, global float* u_global, const float u_w, const float u_e, const int nx, const int ny) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  int two_d_index = y * nx + x;

  if ((x < nx) && (y < ny)) {
    float f0 = f_global[hook(0, 0 * ny * nx + two_d_index)];
    float f1 = f_global[hook(0, 1 * ny * nx + two_d_index)];
    float f2 = f_global[hook(0, 2 * ny * nx + two_d_index)];
    float f3 = f_global[hook(0, 3 * ny * nx + two_d_index)];
    float f4 = f_global[hook(0, 4 * ny * nx + two_d_index)];
    float f5 = f_global[hook(0, 5 * ny * nx + two_d_index)];
    float f6 = f_global[hook(0, 6 * ny * nx + two_d_index)];
    float f7 = f_global[hook(0, 7 * ny * nx + two_d_index)];
    float f8 = f_global[hook(0, 8 * ny * nx + two_d_index)];

    if ((x == 0) && (y >= 1) && (y < ny - 1)) {
      float rho_w = (1. / (1. - u_w)) * (f0 + f2 + f4 + 2 * (f3 + f6 + f7));
      f_global[hook(0, 1 * ny * nx + two_d_index)] = f3 + (2. / 3.) * rho_w * u_w;
      f_global[hook(0, 5 * ny * nx + two_d_index)] = f7 - (1. / 2.) * (f2 - f4) + (1. / 6.) * rho_w * u_w;
      f_global[hook(0, 8 * ny * nx + two_d_index)] = f6 + (1. / 2.) * (f2 - f4) + (1. / 6.) * rho_w * u_w;
    }

    if ((x == nx - 1) && (y >= 1) && (y < ny - 1)) {
      float rho_e = (1. / (1. + u_e)) * (f0 + f2 + f4 + 2. * (f1 + f5 + f8));
      f_global[hook(0, 3 * ny * nx + two_d_index)] = f1 - (2. / 3.) * rho_e * u_e;
      f_global[hook(0, 6 * ny * nx + two_d_index)] = f5 + (1. / 2.) * (f2 - f4) - (1. / 6.) * rho_e * u_e;
      f_global[hook(0, 7 * ny * nx + two_d_index)] = f8 - (1. / 2.) * (f2 - f4) - (1. / 6.) * rho_e * u_e;
    }

    if ((y == ny - 1) && (x >= 0) && (x < nx)) {
      f_global[hook(0, 4 * ny * nx + two_d_index)] = f_global[hook(0, 4 * ny * nx + x)];
      f_global[hook(0, 8 * ny * nx + two_d_index)] = f_global[hook(0, 8 * ny * nx + x)];
      f_global[hook(0, 7 * ny * nx + two_d_index)] = f_global[hook(0, 7 * ny * nx + x)];
    }

    if ((y == 0) && (x >= 0) && (x < nx)) {
      f_global[hook(0, 2 * ny * nx + two_d_index)] = f_global[hook(0, 2 * ny * nx + (ny - 1) * nx + x)];
      f_global[hook(0, 6 * ny * nx + two_d_index)] = f_global[hook(0, 6 * ny * nx + (ny - 1) * nx + x)];
      f_global[hook(0, 5 * ny * nx + two_d_index)] = f_global[hook(0, 5 * ny * nx + (ny - 1) * nx + x)];
    }
  }
}