//{"f_global":1,"nx":2,"ny":3,"obstacle_mask":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bounceback_in_obstacle(global int* obstacle_mask, global float* f_global, const int nx, const int ny) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if ((x < nx) && (y < ny)) {
    const int two_d_index = y * nx + x;
    if (obstacle_mask[hook(0, two_d_index)] == 1) {
      float f1 = f_global[hook(1, 1 * ny * nx + two_d_index)];
      float f2 = f_global[hook(1, 2 * ny * nx + two_d_index)];
      float f3 = f_global[hook(1, 3 * ny * nx + two_d_index)];
      float f4 = f_global[hook(1, 4 * ny * nx + two_d_index)];
      float f5 = f_global[hook(1, 5 * ny * nx + two_d_index)];
      float f6 = f_global[hook(1, 6 * ny * nx + two_d_index)];
      float f7 = f_global[hook(1, 7 * ny * nx + two_d_index)];
      float f8 = f_global[hook(1, 8 * ny * nx + two_d_index)];

      f_global[hook(1, 1 * ny * nx + two_d_index)] = f3;
      f_global[hook(1, 2 * ny * nx + two_d_index)] = f4;
      f_global[hook(1, 3 * ny * nx + two_d_index)] = f1;
      f_global[hook(1, 4 * ny * nx + two_d_index)] = f2;
      f_global[hook(1, 5 * ny * nx + two_d_index)] = f7;
      f_global[hook(1, 6 * ny * nx + two_d_index)] = f8;
      f_global[hook(1, 7 * ny * nx + two_d_index)] = f5;
      f_global[hook(1, 8 * ny * nx + two_d_index)] = f6;
    }
  }
}