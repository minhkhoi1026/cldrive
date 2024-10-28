//{"f_global":0,"feq_global":1,"nx":3,"ny":4,"omega":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void collide_particles(global float* f_global, global float* feq_global, const float omega, const int nx, const int ny) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int jump_id = get_global_id(2);

  if ((x < nx) && (y < ny) && (jump_id < 9)) {
    int three_d_index = jump_id * nx * ny + y * nx + x;

    float f = f_global[hook(0, three_d_index)];
    float feq = feq_global[hook(1, three_d_index)];

    f_global[hook(0, three_d_index)] = f * (1 - omega) + omega * feq;
  }
}