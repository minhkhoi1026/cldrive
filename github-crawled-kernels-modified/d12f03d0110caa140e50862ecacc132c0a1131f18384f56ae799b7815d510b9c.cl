//{"f_global":0,"inlet_rho":2,"nx":4,"ny":5,"outlet_rho":3,"u_global":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void move_bcs(global float* f_global, global float* u_global, const float inlet_rho, const float outlet_rho, const int nx, const int ny) {
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
      float u = -((f0 + f2 + 2 * f3 + f4 + 2 * f6 + 2 * f7 - inlet_rho) / inlet_rho);
      f_global[hook(0, 1 * ny * nx + two_d_index)] = f3 + (2. / 3.) * inlet_rho * u;
      f_global[hook(0, 5 * ny * nx + two_d_index)] = -.5 * f2 + .5 * f4 + f7 + (1. / 6.) * u * inlet_rho;
      f_global[hook(0, 8 * ny * nx + two_d_index)] = .5 * f2 - .5 * f4 + f6 + (1. / 6.) * u * inlet_rho;
    }

    if ((x == nx - 1) && (y >= 1) && (y < ny - 1)) {
      float u = -1 + (f0 + 2 * f1 + f2 + f4 + 2 * f5 + 2 * f8) / outlet_rho;
      f_global[hook(0, 3 * ny * nx + two_d_index)] = f1 - (2. / 3.) * outlet_rho * u;
      f_global[hook(0, 6 * ny * nx + two_d_index)] = -.5 * f2 + .5 * f4 + f8 - (1. / 6.) * u * outlet_rho;
      f_global[hook(0, 7 * ny * nx + two_d_index)] = .5 * f2 - .5 * f4 + f5 - (1. / 6.) * u * outlet_rho;
    }

    if ((y == ny - 1) && (x >= 1) && (x < nx - 1)) {
      f_global[hook(0, 4 * ny * nx + two_d_index)] = f2;
      f_global[hook(0, 8 * ny * nx + two_d_index)] = .5 * (-f1 + f3 + 2 * f6);
      f_global[hook(0, 7 * ny * nx + two_d_index)] = .5 * (f1 - f3 + 2 * f5);
    }

    if ((y == 0) && (x >= 1) && (x < nx - 1)) {
      f_global[hook(0, 2 * ny * nx + two_d_index)] = f4;
      f_global[hook(0, 6 * ny * nx + two_d_index)] = .5 * (f1 - f3 + 2 * f8);
      f_global[hook(0, 5 * ny * nx + two_d_index)] = .5 * (-f1 + f3 + 2 * f7);
    }

    if ((x == 0) && (y == 0)) {
      f_global[hook(0, 1 * ny * nx + two_d_index)] = f3;
      f_global[hook(0, 2 * ny * nx + two_d_index)] = f4;
      f_global[hook(0, 5 * ny * nx + two_d_index)] = f7;
      f_global[hook(0, 6 * ny * nx + two_d_index)] = .5 * (-f0 - 2 * f3 - 2 * f4 - 2 * f7 + inlet_rho);
      f_global[hook(0, 8 * ny * nx + two_d_index)] = .5 * (-f0 - 2 * f3 - 2 * f4 - 2 * f7 + inlet_rho);
    }

    if ((x == 0) && (y == ny - 1)) {
      f_global[hook(0, 1 * ny * nx + two_d_index)] = f3;
      f_global[hook(0, 4 * ny * nx + two_d_index)] = f2;
      f_global[hook(0, 8 * ny * nx + two_d_index)] = f6;
      f_global[hook(0, 5 * ny * nx + two_d_index)] = .5 * (-f0 - 2 * f2 - 2 * f3 - 2 * f6 + inlet_rho);
      f_global[hook(0, 7 * ny * nx + two_d_index)] = .5 * (-f0 - 2 * f2 - 2 * f3 - 2 * f6 + inlet_rho);
    }

    if ((x == nx - 1) && (y == 0)) {
      f_global[hook(0, 3 * ny * nx + two_d_index)] = f1;
      f_global[hook(0, 2 * ny * nx + two_d_index)] = f4;
      f_global[hook(0, 6 * ny * nx + two_d_index)] = f8;
      f_global[hook(0, 5 * ny * nx + two_d_index)] = .5 * (-f0 - 2 * f1 - 2 * f4 - 2 * f8 + outlet_rho);
      f_global[hook(0, 7 * ny * nx + two_d_index)] = .5 * (-f0 - 2 * f1 - 2 * f4 - 2 * f8 + outlet_rho);
    }

    if ((x == nx - 1) && (y == ny - 1)) {
      f_global[hook(0, 3 * ny * nx + two_d_index)] = f1;
      f_global[hook(0, 4 * ny * nx + two_d_index)] = f2;
      f_global[hook(0, 7 * ny * nx + two_d_index)] = f5;
      f_global[hook(0, 6 * ny * nx + two_d_index)] = .5 * (-f0 - 2 * f1 - 2 * f2 - 2 * f5 + outlet_rho);
      f_global[hook(0, 8 * ny * nx + two_d_index)] = .5 * (-f0 - 2 * f1 - 2 * f2 - 2 * f5 + outlet_rho);
    }
  }
}