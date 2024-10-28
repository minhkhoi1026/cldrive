//{"bgr":1,"dstStride":5,"height":3,"srcStride":4,"uyvy":0,"width":2}
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

char clamp_c(int v, int l, int h) {
  if (v > h)
    v = h;
  if (v < l)
    v = l;
  return (char)v;
}

kernel void kernel_uyvy_to_2bgr(global unsigned char* uyvy, global unsigned char* bgr, unsigned int width, unsigned int height, unsigned int srcStride, unsigned int dstStride) {
  int x = get_global_id(0) * 2;
  int y = get_global_id(1);
  int y0, u0, y1, v0, r, g, b;

  int i = (y * srcStride) + (x * 2);

  int j = (y * dstStride) + (x * 3);

  u0 = uyvy[hook(0, i + 0)] - 128;
  y0 = uyvy[hook(0, i + 1)] - 16;
  v0 = uyvy[hook(0, i + 2)] - 128;
  y1 = uyvy[hook(0, i + 3)] - 16;

  r = ((74 * y0) + (102 * v0)) >> 6;
  g = ((74 * y0) - (52 * v0) - (25 * u0)) >> 6;
  b = ((74 * y0) + (129 * u0)) >> 6;

  bgr[hook(1, j + 0)] = clamp_uc(b, 0, 255);
  bgr[hook(1, j + 1)] = clamp_uc(g, 0, 255);
  bgr[hook(1, j + 2)] = clamp_uc(r, 0, 255);

  r = ((74 * y1) + (102 * v0)) >> 6;
  g = ((74 * y1) - (52 * v0) - (25 * u0)) >> 6;
  b = ((74 * y1) + (129 * u0)) >> 6;

  bgr[hook(1, j + 3)] = clamp_uc(b, 0, 255);
  bgr[hook(1, j + 4)] = clamp_uc(g, 0, 255);
  bgr[hook(1, j + 5)] = clamp_uc(r, 0, 255);
}