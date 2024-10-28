//{"f_global":0,"nx":3,"ny":4,"rho_specified":1,"w":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void move_bcs(global float* f_global, const float rho_specified, constant float* w, const int nx, const int ny) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  int two_d_index = y * nx + x;

  bool on_left = (x == 0) && (y >= 1) && (y < ny - 1);
  bool on_right = (x == nx - 1) && (y >= 1) && (y < ny - 1);
  bool on_top = (y == ny - 1) && (x >= 1) && (x < nx - 1);
  bool on_bottom = (y == 0) && (x >= 1) && (x < nx - 1);

  bool on_main_surface = on_left || on_right || on_top || on_bottom;

  bool bottom_left_corner = (x == 0) && (y == 0);
  bool bottom_right_corner = (x == nx - 1) && (y == 0);
  bool upper_left_corner = (x == 0) && (y == ny - 1);
  bool upper_right_corner = (x == nx - 1) && (y == ny - 1);

  bool on_corner = bottom_left_corner || bottom_right_corner || upper_left_corner || upper_right_corner;

  if (on_main_surface || on_corner) {
    float f1 = f_global[hook(0, 1 * ny * nx + two_d_index)];
    float f2 = f_global[hook(0, 2 * ny * nx + two_d_index)];
    float f3 = f_global[hook(0, 3 * ny * nx + two_d_index)];
    float f4 = f_global[hook(0, 4 * ny * nx + two_d_index)];
    float f5 = f_global[hook(0, 5 * ny * nx + two_d_index)];
    float f6 = f_global[hook(0, 6 * ny * nx + two_d_index)];
    float f7 = f_global[hook(0, 7 * ny * nx + two_d_index)];
    float f8 = f_global[hook(0, 8 * ny * nx + two_d_index)];

    if (on_top) {
      float rho_to_add = -(f1 + f2 + f3 + f5 + f6 + (-1 + w[hook(2, 0)]) * rho_specified) / (w[hook(2, 4)] + w[hook(2, 7)] + w[hook(2, 8)]);
      f_global[hook(0, 7 * ny * nx + two_d_index)] = w[hook(2, 7)] * rho_to_add;
      f_global[hook(0, 4 * ny * nx + two_d_index)] = w[hook(2, 4)] * rho_to_add;
      f_global[hook(0, 8 * ny * nx + two_d_index)] = w[hook(2, 8)] * rho_to_add;
    }

    if (on_right) {
      float rho_to_add = -(f1 + f2 + f4 + f5 + f8 + (-1 + w[hook(2, 0)]) * rho_specified) / (w[hook(2, 3)] + w[hook(2, 6)] + w[hook(2, 7)]);
      f_global[hook(0, 3 * ny * nx + two_d_index)] = w[hook(2, 3)] * rho_to_add;
      f_global[hook(0, 6 * ny * nx + two_d_index)] = w[hook(2, 6)] * rho_to_add;
      f_global[hook(0, 7 * ny * nx + two_d_index)] = w[hook(2, 7)] * rho_to_add;
    }

    if (on_bottom) {
      float rho_to_add = -(f1 + f3 + f4 + f7 + f8 + (-1 + w[hook(2, 0)]) * rho_specified) / (w[hook(2, 2)] + w[hook(2, 5)] + w[hook(2, 6)]);
      f_global[hook(0, 2 * ny * nx + two_d_index)] = w[hook(2, 2)] * rho_to_add;
      f_global[hook(0, 5 * ny * nx + two_d_index)] = w[hook(2, 5)] * rho_to_add;
      f_global[hook(0, 6 * ny * nx + two_d_index)] = w[hook(2, 6)] * rho_to_add;
    }

    if (on_left) {
      float rho_to_add = -(f2 + f3 + f4 + f6 + f7 + (-1 + w[hook(2, 0)]) * rho_specified) / (w[hook(2, 1)] + w[hook(2, 5)] + w[hook(2, 8)]);
      f_global[hook(0, 1 * ny * nx + two_d_index)] = w[hook(2, 1)] * rho_to_add;
      f_global[hook(0, 5 * ny * nx + two_d_index)] = w[hook(2, 5)] * rho_to_add;
      f_global[hook(0, 8 * ny * nx + two_d_index)] = w[hook(2, 8)] * rho_to_add;
    }

    if (bottom_left_corner) {
      float rho_to_add = -(f3 + f4 + f6 + f7 + f8 + (-1 + w[hook(2, 0)]) * rho_specified) / (w[hook(2, 1)] + w[hook(2, 2)] + w[hook(2, 5)]);
      f_global[hook(0, 1 * ny * nx + two_d_index)] = w[hook(2, 1)] * rho_to_add;
      f_global[hook(0, 2 * ny * nx + two_d_index)] = w[hook(2, 2)] * rho_to_add;
      f_global[hook(0, 5 * ny * nx + two_d_index)] = w[hook(2, 5)] * rho_to_add;
    }

    if (bottom_right_corner) {
      float rho_to_add = -(f1 + f4 + f5 + f7 + f8 + (-1 + w[hook(2, 0)]) * rho_specified) / (w[hook(2, 2)] + w[hook(2, 3)] + w[hook(2, 6)]);
      f_global[hook(0, 2 * ny * nx + two_d_index)] = w[hook(2, 2)] * rho_to_add;
      f_global[hook(0, 3 * ny * nx + two_d_index)] = w[hook(2, 3)] * rho_to_add;
      f_global[hook(0, 6 * ny * nx + two_d_index)] = w[hook(2, 6)] * rho_to_add;
    }

    if (upper_left_corner) {
      float rho_to_add = -(f2 + f3 + f5 + f6 + f7 + (-1 + w[hook(2, 0)]) * rho_specified) / (w[hook(2, 1)] + w[hook(2, 4)] + w[hook(2, 8)]);
      f_global[hook(0, 1 * ny * nx + two_d_index)] = w[hook(2, 1)] * rho_to_add;
      f_global[hook(0, 4 * ny * nx + two_d_index)] = w[hook(2, 4)] * rho_to_add;
      f_global[hook(0, 8 * ny * nx + two_d_index)] = w[hook(2, 8)] * rho_to_add;
    }

    if (upper_right_corner) {
      float rho_to_add = -(f1 + f2 + f5 + f6 + f8 + (-1 + w[hook(2, 0)]) * rho_specified) / (w[hook(2, 3)] + w[hook(2, 4)] + w[hook(2, 7)]);
      f_global[hook(0, 3 * ny * nx + two_d_index)] = w[hook(2, 3)] * rho_to_add;
      f_global[hook(0, 4 * ny * nx + two_d_index)] = w[hook(2, 4)] * rho_to_add;
      f_global[hook(0, 7 * ny * nx + two_d_index)] = w[hook(2, 7)] * rho_to_add;
    }
  }
}