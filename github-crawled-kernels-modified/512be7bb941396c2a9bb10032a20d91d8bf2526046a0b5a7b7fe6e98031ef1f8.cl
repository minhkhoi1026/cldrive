//{"blendmap":2,"h":6,"lmap":3,"n":1,"out":4,"pyramid":0,"w":5,"x":7,"y":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float _distance_2_point(float x, float y, float rx, float ry, float sw, float sh, float ez, float ex, float ey) {
  float dx = x / rx * sw - sw / 2.0f + ex;
  float dy = y / ry * sh - sh / 2.0f - ey;
  return sqrt(ez * ez + dx * dx + dy * dy);
}

kernel void blend(global unsigned char* pyramid, unsigned int n, global float* blendmap, global unsigned int* lmap, global unsigned char* out, unsigned int w, unsigned int h, unsigned int x, unsigned int y) {
  unsigned int c = get_global_id(0);
  unsigned int r = get_global_id(1);

  unsigned int bx = (w + 1) / 2 - x;
  unsigned int by = (h + 1) / 2 - y;
  unsigned int j = (r + by) * w + (c + bx);
  unsigned int l = lmap[hook(3, j)];
  float b = blendmap[hook(2, j)];

  unsigned int k = r * w + c;
  float v1 = pyramid[hook(0, l * n + k)];
  float v2 = pyramid[hook(0, (l - 1) * n + k)];

  out[hook(4, k)] = (v1 * (1 - b) + v2 * b);
}