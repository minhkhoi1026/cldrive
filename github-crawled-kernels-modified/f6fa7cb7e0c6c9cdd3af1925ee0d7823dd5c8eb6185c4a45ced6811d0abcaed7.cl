//{"H":2,"W":3,"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void erode_unrolled(global uchar* src, global uchar* dst, const int H, const int W) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  uchar p1, p2, p3;
  uchar p4, p5, p6;
  uchar p7, p8, p9;
  if (i > H || j > W)
    return;
  if ((p5 = src[hook(0, (i) * W + j)])) {
    p1 = src[hook(0, (i - 1) * W + j - 1)];
    p2 = src[hook(0, (i - 1) * W + j)];
    p3 = src[hook(0, (i - 1) * W + j + 1)];
    p4 = src[hook(0, (i) * W + j - 1)];
    p6 = src[hook(0, (i) * W + j + 1)];
    p7 = src[hook(0, (i + 1) * W + j - 1)];
    p8 = src[hook(0, (i + 1) * W + j)];
    p9 = src[hook(0, (i + 1) * W + j + 1)];
    dst[hook(1, (i) * W + j)] = (p1 && p2 && p3 && p4 && p5 && p6 && p7 && p8 && p9);
  }
}