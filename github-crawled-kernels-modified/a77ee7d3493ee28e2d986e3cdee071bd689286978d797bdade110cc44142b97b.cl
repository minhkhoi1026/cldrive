//{"f_global":0,"inlet_rho":4,"nx":6,"ny":7,"outlet_rho":5,"rho_global":3,"u_global":1,"v_global":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void update_hydro(global float* f_global, global float* u_global, global float* v_global, global float* rho_global, const float inlet_rho, const float outlet_rho, const int nx, const int ny) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if ((x < nx) && (y < ny)) {
    int two_d_index = y * nx + x;
    float f0 = f_global[hook(0, 0 * ny * nx + two_d_index)];
    float f1 = f_global[hook(0, 1 * ny * nx + two_d_index)];
    float f2 = f_global[hook(0, 2 * ny * nx + two_d_index)];
    float f3 = f_global[hook(0, 3 * ny * nx + two_d_index)];
    float f4 = f_global[hook(0, 4 * ny * nx + two_d_index)];
    float f5 = f_global[hook(0, 5 * ny * nx + two_d_index)];
    float f6 = f_global[hook(0, 6 * ny * nx + two_d_index)];
    float f7 = f_global[hook(0, 7 * ny * nx + two_d_index)];
    float f8 = f_global[hook(0, 8 * ny * nx + two_d_index)];

    float rho = f0 + f1 + f2 + f3 + f4 + f5 + f6 + f7 + f8;
    rho_global[hook(3, two_d_index)] = rho;
    float inverse_rho = 1. / rho;

    u_global[hook(1, two_d_index)] = (f1 - f3 + f5 - f6 - f7 + f8) * inverse_rho;
    v_global[hook(2, two_d_index)] = (f5 + f2 + f6 - f7 - f4 - f8) * inverse_rho;
  }
}