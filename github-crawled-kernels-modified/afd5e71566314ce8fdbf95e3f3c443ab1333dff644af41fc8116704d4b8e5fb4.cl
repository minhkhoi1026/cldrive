//{"H":2,"W":3,"dst":1,"ksize":4,"smem":6,"smem[i + 16]":7,"smem[i + dy]":8,"smem[i]":5,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void erode_smem7(global uchar* src, global uchar* dst, const int H, const int W, const int ksize) {
  local uchar smem[16 + 2 * 3][16 + 2 * 3];

  int i = get_local_id(0);
  int j = get_local_id(1);
  int ii = get_global_id(0);
  int jj = get_global_id(1);
  int sum = 0, dy, dx, in;
  const int tot = ksize * ksize;

  ii -= 3;
  jj -= 3;
  in = ii >= 0 && jj >= 0;
  smem[hook(6, i)][hook(5, j)] = in ? src[hook(0, (ii) * W + jj)] : 0;
  if (i < 3 * 2) {
    in = jj >= 0 && ii + 16 < H;
    smem[hook(6, i + 16)][hook(7, j)] = in ? src[hook(0, (ii + 16) * W + jj)] : 0;
  }
  if (j < 3 * 2) {
    in = ii >= 0 && jj + 16 < W;
    smem[hook(6, i)][hook(5, j + 16)] = in ? src[hook(0, (ii) * W + jj + 16)] : 0;
  }
  if (i < 3 * 2 && j < 3 * 2) {
    in = ii + 16 < H && jj + 16 < W;
    smem[hook(6, i + 16)][hook(7, j + 16)] = in ? src[hook(0, (ii + 16) * W + jj + 16)] : 0;
  }
  i += 3;
  j += 3;
  ii += 3;
  jj += 3;
  barrier(0x01);

  if (ii > H || jj > W || !src[hook(0, (ii) * W + jj)])
    return;
  for (dy = -3; dy <= 3; dy++) {
    for (dx = -3; dx <= 3; dx++) {
      sum += smem[hook(6, i + dy)][hook(8, j + dx)];
    }
  }
  dst[hook(1, (ii) * W + jj)] = sum == tot;
}