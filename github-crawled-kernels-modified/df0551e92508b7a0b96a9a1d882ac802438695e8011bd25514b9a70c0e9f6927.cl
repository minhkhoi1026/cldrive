//{"f_global":0,"nx":4,"ny":5,"rho_global":3,"u_global":1,"v_global":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void update_hydro_diffusion(global float* f_global, global float* u_global, global float* v_global, global float* rho_global, const int nx, const int ny) {
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

    rho_global[hook(3, two_d_index)] = f0 + f1 + f2 + f3 + f4 + f5 + f6 + f7 + f8;
  }
}