//{"h":3,"p":0,"semilla":1,"w":2}
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
kernel void calc_particles_trans(global struct float4* restrict p, const int semilla, const int w, const int h) {
  int base = get_global_id(0);
  float new_x, new_y, new_s;
  int estadoN1 = ((semilla * base * 214013) + 2531011) % 2147483648;
  float xCero = p[hook(0, base)].x0;
  float yCero = p[hook(0, base)].y0;
  float x = p[hook(0, base)].x;
  float y = p[hook(0, base)].y;
  float s = p[hook(0, base)].s;

  new_x = 2.0f * (x - xCero) + -1.0f * (p[hook(0, base)].xp - xCero) + 1.0000f * (float)ran_gaussian(&estadoN1, 1.0) + xCero;
  new_y = 2.0f * (y - yCero) + -1.0f * (p[hook(0, base)].yp - yCero) + 1.0000f * (float)ran_gaussian(&estadoN1, 0.5) + yCero;
  new_s = 2.0f * (s - 1.0f) + -1.0f * (p[hook(0, base)].sp - 1.0f) + 1.0000f * (float)ran_gaussian(&estadoN1, 0.001) + 1.0f;

  p[hook(0, base)].xp = x;
  p[hook(0, base)].yp = y;
  p[hook(0, base)].sp = s;
  p[hook(0, base)].x = ((0.0f) < ((((float)w - 1.0f) > (new_x) ? (new_x) : ((float)w - 1.0f))) ? ((((float)w - 1.0f) > (new_x) ? (new_x) : ((float)w - 1.0f))) : (0.0f));
  p[hook(0, base)].y = ((0.0f) < ((((float)h - 1.0f) > (new_y) ? (new_y) : ((float)h - 1.0f))) ? ((((float)h - 1.0f) > (new_y) ? (new_y) : ((float)h - 1.0f))) : (0.0f));
  p[hook(0, base)].s = ((0.1f) < (new_s) ? (new_s) : (0.1f));
  p[hook(0, base)].w = 0.0f;
}