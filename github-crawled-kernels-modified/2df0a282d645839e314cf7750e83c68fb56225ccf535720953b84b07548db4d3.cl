//{"H":2,"W":3,"dst":1,"ksize":4,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void erode(global uchar* src, global uchar* dst, const int H, const int W, const int ksize) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  int sum = 0, dy, dx;
  const int R = ksize / 2;
  const int tot = ksize * ksize;
  if (i > H || j > W || !src[hook(0, (i) * W + j)])
    return;
  for (dy = -R; dy <= R; dy++) {
    for (dx = -R; dx <= R; dx++) {
      sum += src[hook(0, (i + dy) * W + j + dx)];
    }
  }
  dst[hook(1, (i) * W + j)] = sum == tot;
}