//{"dstStride":2,"gray":4,"rgb":3,"srcStride":1,"yuyv":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned char clamp_uc(int v, int l, int h) {
  if (v > h)
    v = h;
  if (v < l)
    v = l;
  return (unsigned char)v;
}

kernel void grayKernel(global unsigned char* restrict yuyv, unsigned int srcStride, unsigned int dstStride, global unsigned char* restrict rgb, global unsigned char* restrict gray) {
  int x = get_global_id(0) * 2;
  int y = get_global_id(1);
  int y0, u0, y1, v0, r, g, b;

  int i = (y * srcStride) + (x * 2);

  int j = (y * dstStride) + (x * 4);

  int k = (y * srcStride >> 1) + x;

  y0 = yuyv[hook(0, i + 0)] - 16;
  u0 = yuyv[hook(0, i + 1)] - 128;
  y1 = yuyv[hook(0, i + 2)] - 16;
  v0 = yuyv[hook(0, i + 3)] - 128;

  r = clamp_uc(((74 * y0) + (102 * v0)) >> 6, 0, 255);
  g = clamp_uc(((74 * y0) - (52 * v0) - (25 * u0)) >> 6, 0, 255);
  b = clamp_uc(((74 * y0) + (129 * u0)) >> 6, 0, 255);

  rgb[hook(3, j + 0)] = r;
  rgb[hook(3, j + 1)] = g;
  rgb[hook(3, j + 2)] = b;
  rgb[hook(3, j + 3)] = 255;
  gray[hook(4, k + 0)] = clamp_uc((77 * r + 151 * g + 28 * b) >> 8, 0, 255);

  r = clamp_uc(((74 * y1) + (102 * v0)) >> 6, 0, 255);
  g = clamp_uc(((74 * y1) - (52 * v0) - (25 * u0)) >> 6, 0, 255);
  b = clamp_uc(((74 * y1) + (129 * u0)) >> 6, 0, 255);

  rgb[hook(3, j + 4)] = r;
  rgb[hook(3, j + 5)] = g;
  rgb[hook(3, j + 6)] = b;
  rgb[hook(3, j + 7)] = 255;
  gray[hook(4, k + 1)] = clamp_uc((77 * r + 151 * g + 28 * b) >> 8, 0, 255);
}