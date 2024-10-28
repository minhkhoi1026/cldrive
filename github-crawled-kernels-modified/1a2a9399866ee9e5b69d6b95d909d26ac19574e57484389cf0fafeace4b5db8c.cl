//{"height":2,"result":0,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sphere(global uchar* result, unsigned int width, unsigned int height) {
  unsigned int x = get_global_id(0), y = get_global_id(1);
  unsigned int index = (y * width + x) * 3;

  result[hook(0, index + 0)] = 64;
  result[hook(0, index + 1)] = 160;
  result[hook(0, index + 2)] = 255;

  double4 eye = (double4)(0.0, 0.0, 128.0, 0.0);
  double4 sphere = (double4)(0.0, 0.0, -64.0, 0.0);
  double sphere_size = 32.0;
  double4 dlight = normalize((double4)(1.0, 2.0, 2.0, 0.0));

  double4 screen = (double4)(x * 0.25 - 31.5, 31.5 - y * 0.25, 0.0, 0.0);
  double4 ray = normalize(screen - eye);

  double4 v = sphere - eye;
  double d = dot(v, ray);
  if (d > 0.0) {
    double4 p = ray * d + eye;
    v = sphere - p;
    double len = length(v);
    if (len < sphere_size) {
      len /= sphere_size;
      d = sqrt(-len * len + 1.0 * 1.0) * sphere_size;

      p = ray * (-d) + p;

      double4 nrm = normalize(p - sphere);

      d = max(dot(nrm, dlight), 0.0);

      result[hook(0, index + 0)] = 255 * d;
      result[hook(0, index + 1)] = 230 * d;
      result[hook(0, index + 2)] = 206 * d;
    }
  }
}