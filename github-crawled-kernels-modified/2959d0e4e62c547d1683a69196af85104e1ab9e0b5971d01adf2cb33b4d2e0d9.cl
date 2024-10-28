//{"Gx_global":3,"Gy_global":4,"field_num":0,"force_x":1,"force_y":2,"nx":5,"ny":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_constant_body_force(const int field_num, const double force_x, const double force_y, global double* Gx_global, global double* Gy_global, const int nx, const int ny) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if ((x < nx) && (y < ny)) {
    int three_d_index = field_num * nx * ny + y * nx + x;

    Gx_global[hook(3, three_d_index)] += force_x;
    Gy_global[hook(4, three_d_index)] += force_y;
  }
}