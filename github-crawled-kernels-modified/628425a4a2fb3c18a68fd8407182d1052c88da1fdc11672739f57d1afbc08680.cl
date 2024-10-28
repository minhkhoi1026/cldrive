//{"f_global":0,"feq_global":1,"nx":3,"ny":4,"omega":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void collide_particles(global float* f_global, global float* feq_global, const float omega, const int nx, const int ny) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if ((x < nx) && (y < ny)) {
    const int two_d_index = y * nx + x;

    for (int jump_id = 0; jump_id < 9; jump_id++) {
      int three_d_index = jump_id * nx * ny + two_d_index;

      float f = f_global[hook(0, three_d_index)];
      float feq = feq_global[hook(1, three_d_index)];

      f_global[hook(0, three_d_index)] = f * (1 - omega) + omega * feq;
    }
  }
}