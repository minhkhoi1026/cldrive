//{"f_global":0,"num_populations":4,"nx":2,"ny":3,"w":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void move_bcs(global float* f_global, constant float* w, const int nx, const int ny, const int num_populations) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  const bool on_left = (x == 0) && (y >= 1) && (y < ny - 1);
  const bool on_right = (x == nx - 1) && (y >= 1) && (y < ny - 1);
  const bool on_top = (y == ny - 1) && (x >= 1) && (x < nx - 1);
  const bool on_bottom = (y == 0) && (x >= 1) && (x < nx - 1);

  const bool on_main_surface = on_left || on_right || on_top || on_bottom;

  const bool bottom_left_corner = (x == 0) && (y == 0);
  const bool bottom_right_corner = (x == nx - 1) && (y == 0);
  const bool upper_left_corner = (x == 0) && (y == ny - 1);
  const bool upper_right_corner = (x == nx - 1) && (y == ny - 1);

  const bool on_corner = bottom_left_corner || bottom_right_corner || upper_left_corner || upper_right_corner;

  const int two_d_index = y * nx + x;
  const int four_d_prefactor = ny * nx * num_populations;

  if (on_main_surface || on_corner) {
    for (int field_num = 0; field_num < num_populations; field_num++) {
      int three_d_index = field_num * nx * ny + two_d_index;

      float f1 = f_global[hook(0, 1 * four_d_prefactor + three_d_index)];
      float f2 = f_global[hook(0, 2 * four_d_prefactor + three_d_index)];
      float f3 = f_global[hook(0, 3 * four_d_prefactor + three_d_index)];
      float f4 = f_global[hook(0, 4 * four_d_prefactor + three_d_index)];
      float f5 = f_global[hook(0, 5 * four_d_prefactor + three_d_index)];
      float f6 = f_global[hook(0, 6 * four_d_prefactor + three_d_index)];
      float f7 = f_global[hook(0, 7 * four_d_prefactor + three_d_index)];
      float f8 = f_global[hook(0, 8 * four_d_prefactor + three_d_index)];

      if (on_top) {
        f_global[hook(0, 7 * four_d_prefactor + three_d_index)] = f5;
        f_global[hook(0, 4 * four_d_prefactor + three_d_index)] = f2;
        f_global[hook(0, 8 * four_d_prefactor + three_d_index)] = f6;
      }

      if (on_bottom) {
        f_global[hook(0, 2 * four_d_prefactor + three_d_index)] = f4;
        f_global[hook(0, 5 * four_d_prefactor + three_d_index)] = f7;
        f_global[hook(0, 6 * four_d_prefactor + three_d_index)] = f8;
      }

      if (on_right) {
        f_global[hook(0, 3 * four_d_prefactor + three_d_index)] = f1;
        f_global[hook(0, 6 * four_d_prefactor + three_d_index)] = f8;
        f_global[hook(0, 7 * four_d_prefactor + three_d_index)] = f5;
      }

      if (on_left) {
        f_global[hook(0, 1 * four_d_prefactor + three_d_index)] = f3;
        f_global[hook(0, 5 * four_d_prefactor + three_d_index)] = f7;
        f_global[hook(0, 8 * four_d_prefactor + three_d_index)] = f6;
      }

      if (upper_left_corner) {
        f_global[hook(0, 1 * four_d_prefactor + three_d_index)] = f3;
        f_global[hook(0, 4 * four_d_prefactor + three_d_index)] = f2;
        f_global[hook(0, 8 * four_d_prefactor + three_d_index)] = f6;
      }

      if (upper_right_corner) {
        f_global[hook(0, 3 * four_d_prefactor + three_d_index)] = f1;
        f_global[hook(0, 4 * four_d_prefactor + three_d_index)] = f2;
        f_global[hook(0, 7 * four_d_prefactor + three_d_index)] = f5;
      }

      if (bottom_right_corner) {
        f_global[hook(0, 2 * four_d_prefactor + three_d_index)] = f4;
        f_global[hook(0, 3 * four_d_prefactor + three_d_index)] = f1;
        f_global[hook(0, 6 * four_d_prefactor + three_d_index)] = f8;
      }

      if (bottom_left_corner) {
        f_global[hook(0, 1 * four_d_prefactor + three_d_index)] = f3;
        f_global[hook(0, 2 * four_d_prefactor + three_d_index)] = f4;
        f_global[hook(0, 5 * four_d_prefactor + three_d_index)] = f7;
      }
    }
  }
}