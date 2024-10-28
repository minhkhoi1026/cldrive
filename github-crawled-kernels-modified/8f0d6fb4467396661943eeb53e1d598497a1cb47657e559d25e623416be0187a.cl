//{"f_global":0,"num_populations":6,"nx":4,"ny":5,"rho_global":3,"u_global":1,"v_global":2,"zero_cutoff":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void update_hydro(global float* f_global, global float* u_global, global float* v_global, global float* rho_global, const int nx, const int ny, const int num_populations, const float zero_cutoff) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int num_fields = num_populations + 1;

  if ((x < nx) && (y < ny)) {
    const int two_d_index = y * nx + x;

    for (int field_num = 0; field_num < num_fields; field_num++) {
      int three_d_index = field_num * nx * ny + two_d_index;

      float f_sum = 0;
      for (int jump_id = 0; jump_id < 9; jump_id++) {
        f_sum += f_global[hook(0, jump_id * num_fields * nx * ny + three_d_index)];
      }
      if ((f_sum < zero_cutoff) || isnan(f_sum))
        f_sum = 0;
      rho_global[hook(3, three_d_index)] = f_sum;
    }
  }
}