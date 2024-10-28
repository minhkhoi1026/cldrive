//{"max_it":4,"out":0,"res":3,"x0":1,"y0":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mandel(global float* out, float x0, float y0, float res, unsigned max_it) {
  unsigned i = get_global_id(0), j = get_global_id(1);

  size_t address = i + j * get_global_size(0);

  float cx = x0 + res * i, cy = y0 + res * j, zx = 0, zy = 0, w = 0;

  unsigned k = 0;
  while (k < max_it && w < 4.0) {
    float u = zx * zx - zy * zy, v = 2 * zx * zy;

    zx = u + cx;
    zy = v + cy;

    w = zx * zx + zy * zy;
    ++k;
  }

  out[hook(0, address)] = (k == max_it ? 1.0 : (float)k / max_it);
}