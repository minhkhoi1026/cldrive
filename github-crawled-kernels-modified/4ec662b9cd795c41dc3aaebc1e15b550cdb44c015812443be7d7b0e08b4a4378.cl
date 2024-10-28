//{"n":1,"particles":0}
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

kernel void calc_particles_init(global struct float4* particles, int n) {
  int base = get_global_id(0);
  int tam = get_global_size(0);

  for (int j = base; j < n; j += tam) {
    particles[hook(0, j)].x0 = 0.0f;
    particles[hook(0, j)].xp = 0.0f;
    particles[hook(0, j)].x = 0.0f;
    particles[hook(0, j)].y0 = 0.0f;
    particles[hook(0, j)].yp = 0.0f;
    particles[hook(0, j)].y = 0.0f;
    particles[hook(0, j)].sp = 1.0f;
    particles[hook(0, j)].s = 1.0f;
    particles[hook(0, j)].width = 500;
    particles[hook(0, j)].height = 500;
    particles[hook(0, j)].w = 0.0f;
  }
}