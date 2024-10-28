//{"dstStride":5,"height":3,"pLuma":1,"pYUV420":0,"srcStride":4,"width":2}
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

kernel void kernel_yuv420_to_luma(global uchar* pYUV420, global uchar* pLuma, unsigned int width, unsigned int height, int srcStride, int dstStride) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  int i = (y * srcStride) + x;
  int j = (y * dstStride) + x;

  pLuma[hook(1, j)] = pYUV420[hook(0, i)];
}