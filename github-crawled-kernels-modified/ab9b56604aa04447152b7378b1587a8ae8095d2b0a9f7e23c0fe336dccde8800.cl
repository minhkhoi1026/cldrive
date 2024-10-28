//{"dstStride":5,"height":1,"limit":9,"n":7,"operator":6,"pDst":4,"pSrc":2,"plA":10,"plOp":11,"range":8,"srcStride":3,"width":0}
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

kernel void kernel_edge_filter_opt(unsigned int width, unsigned int height, global uchar* pSrc, int srcStride, global uchar* pDst, int dstStride, global char* operator, unsigned int n, unsigned int range, unsigned int limit, local uchar * plA, local char * plOp) {
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
    for (q = 0, b = y - nh; q < n, b <= y + nh; q++, b++) {
      for (r = 0, a = x - nh; r < n, a <= x + nh; r++, a++) {
        i = (b * srcStride) + a;
        s = (p * n * n) + (q * n) + r;

        if ((b < 0) || (b >= height) || (a < 0) || (a >= width)) {
          plA[hook(10, s)] = 0;
        } else {
          plA[hook(10, s)] = pSrc[hook(2, i)];
        }
        plOp[hook(11, s)] = operator[hook(6, s)];
      }
    }
  }
  barrier(0x01);

  grad += plOp[hook(11, 0)] * plA[hook(10, 0)] + plOp[hook(11, 1)] * plA[hook(10, 1)] + plOp[hook(11, 2)] * plA[hook(10, 2)];
  grad += plOp[hook(11, 3)] * plA[hook(10, 3)] + plOp[hook(11, 4)] * plA[hook(10, 4)] + plOp[hook(11, 5)] * plA[hook(10, 5)];
  grad += plOp[hook(11, 6)] * plA[hook(10, 6)] + plOp[hook(11, 7)] * plA[hook(10, 7)] + plOp[hook(11, 8)] * plA[hook(10, 8)];
  sum += (grad * grad);

  grad += plOp[hook(11, 9)] * plA[hook(10, 0)] + plOp[hook(11, 10)] * plA[hook(10, 1)] + plOp[hook(11, 11)] * plA[hook(10, 2)];
  grad += plOp[hook(11, 12)] * plA[hook(10, 3)] + plOp[hook(11, 13)] * plA[hook(10, 4)] + plOp[hook(11, 14)] * plA[hook(10, 5)];
  grad += plOp[hook(11, 15)] * plA[hook(10, 6)] + plOp[hook(11, 16)] * plA[hook(10, 7)] + plOp[hook(11, 17)] * plA[hook(10, 8)];
  sum += (grad * grad);

  g = sqrt((float)sum);

  j = (y * dstStride) + x;

  pDst[hook(4, j)] = ((g / range) * limit);
}