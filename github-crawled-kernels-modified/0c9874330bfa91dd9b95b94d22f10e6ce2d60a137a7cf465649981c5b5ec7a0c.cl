//{"dstStride":5,"height":1,"limit":9,"n":7,"operator":6,"pDst":4,"pSrc":2,"range":8,"srcStride":3,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
uchar clamp_uc(float a, uchar l, uchar h) {
  if ((unsigned int)a > (unsigned int)h)
    return h;
  if ((int)a < (int)l)
    return l;
  return (uchar)a;
}

kernel void kernel_edge_filter(unsigned int width, unsigned int height, global uchar* pSrc, int srcStride, global uchar* pDst, int dstStride, global char* operator, unsigned int n, unsigned int range, unsigned int limit) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  int i, j;
  int a, b;
  int p, q, r;
  int s;
  int nh = n >> 1;
  int grad = 0;
  int sum = 0;
  float g = 0;
  for (p = 0; p < 2; p++) {
    grad = 0;
    for (q = 0, b = y - nh; q < n, b <= y + nh; q++, b++) {
      if (b < 0)
        continue;
      if (b >= height)
        continue;

      for (r = 0, a = x - nh; r < n, a <= x + nh; r++, a++) {
        if (a < 0)
          continue;
        if (a >= width)
          continue;

        i = (b * srcStride) + a;

        s = (p * n * n) + (q * n) + r;
        grad += (int)((int)operator[hook(6, s)] *(unsigned int) pSrc[hook(2, i)]);
      }
    }
    sum += (grad * grad);
  }
  j = (y * dstStride) + x;
  g = sqrt((float)sum);
  pDst[hook(4, j)] = ((g / range) * limit);
}