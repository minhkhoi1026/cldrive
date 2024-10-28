//{"particles_pos":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void init_particles_sphere(global unsigned int* particles_pos) {
  size_t x;

  x = get_global_id(0);

  particles_pos[hook(0, x)] = 10.f;
}