//{"particles":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct float4 {
  float x;
  float y;
  float s;
  float xp;
  float yp;
  float sp;
  float x0;
  float y0;
  int width;
  int height;
  float w;
};

kernel void calc_particles_init(global struct float4* restrict particles) {
  int base = get_global_id(0);

  particles[hook(0, base)].x0 = 0.0f;
  particles[hook(0, base)].xp = 0.0f;
  particles[hook(0, base)].x = 0.0f;
  particles[hook(0, base)].y0 = 0.0f;
  particles[hook(0, base)].yp = 0.0f;
  particles[hook(0, base)].y = 0.0f;
  particles[hook(0, base)].sp = 1.0f;
  particles[hook(0, base)].s = 1.0f;
  particles[hook(0, base)].width = 500;
  particles[hook(0, base)].height = 500;
  particles[hook(0, base)].w = 0.0f;
}