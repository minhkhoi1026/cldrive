//{"h":4,"n":2,"p":0,"semilla":1,"w":3}
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
double ran_gaussian(int* estadoN1, const double sigma) {
  double x, y, r2;
  do {
    *estadoN1 = (214013 * (*estadoN1) + 2531011) % 2147483648;
    double u1 = (*estadoN1) / 2147483648.0;
    *estadoN1 = (214013 * (*estadoN1) + 2531011) % 2147483648;
    double u2 = (*estadoN1) / 2147483648.0;

    x = -1.0 + 2.0 * u1;
    y = -1.0 + 2.0 * u2;

    r2 = x * x + y * y;
  } while (r2 > 1.0 || r2 == 0);

  return sigma * y * sqrt(-2.0 * log(r2) / r2);
}
kernel void calc_particles_trans(global struct float4* p, int semilla, int n, int w, int h) {
  int base = get_global_id(0);
  int tam = get_global_size(0);
  float x, y, s;
  int estadoN1 = ((semilla * base * 214013) + 2531011) % 2147483648;

  for (int i = base; i < n; i += tam) {
    x = 2.0f * (p[hook(0, i)].x - p[hook(0, i)].x0) + -1.0f * (p[hook(0, i)].xp - p[hook(0, i)].x0) + 1.0000f * (float)ran_gaussian(&estadoN1, 1.0) + p[hook(0, i)].x0;
    y = 2.0f * (p[hook(0, i)].y - p[hook(0, i)].y0) + -1.0f * (p[hook(0, i)].yp - p[hook(0, i)].y0) + 1.0000f * (float)ran_gaussian(&estadoN1, 0.5) + p[hook(0, i)].y0;
    s = 2.0f * (p[hook(0, i)].s - 1.0f) + -1.0f * (p[hook(0, i)].sp - 1.0f) + 1.0000f * (float)ran_gaussian(&estadoN1, 0.001) + 1.0f;

    p[hook(0, i)].xp = p[hook(0, i)].x;
    p[hook(0, i)].yp = p[hook(0, i)].y;
    p[hook(0, i)].sp = p[hook(0, i)].s;
    p[hook(0, i)].x = ((0.0f) < ((((float)w - 1.0f) > (x) ? (x) : ((float)w - 1.0f))) ? ((((float)w - 1.0f) > (x) ? (x) : ((float)w - 1.0f))) : (0.0f));
    p[hook(0, i)].y = ((0.0f) < ((((float)h - 1.0f) > (y) ? (y) : ((float)h - 1.0f))) ? ((((float)h - 1.0f) > (y) ? (y) : ((float)h - 1.0f))) : (0.0f));
    p[hook(0, i)].s = ((0.1f) < (s) ? (s) : (0.1f));
    p[hook(0, i)].w = 0.0f;
  }
}