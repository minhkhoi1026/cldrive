//{"nx":3,"ny":4,"obstacle_mask":0,"u_global":1,"v_global":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_zero_velocity_in_obstacle(global int* obstacle_mask, global float* u_global, global float* v_global, const int nx, const int ny) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if ((x < nx) && (y < ny)) {
    const int two_d_index = y * nx + x;

    if (obstacle_mask[hook(0, two_d_index)] == 1) {
      u_global[hook(1, two_d_index)] = 0;
      v_global[hook(2, two_d_index)] = 0;
    }
  }
}