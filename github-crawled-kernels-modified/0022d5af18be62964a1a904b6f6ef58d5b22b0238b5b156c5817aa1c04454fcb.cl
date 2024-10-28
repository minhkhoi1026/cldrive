//{"cols":4,"dst":2,"dst_offset":11,"dst_step":6,"kHeight":9,"kWidth":8,"k_step":7,"koffset":12,"rows":3,"smem":14,"smem[y + 16]":15,"smem[y + 8 - kHeight / 2 + i]":16,"smem[y]":13,"src":0,"src_offset":10,"src_step":5,"temp1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve_D5(global float* src, global float* temp1, global float* dst, int rows, int cols, int src_step, int dst_step, int k_step, int kWidth, int kHeight, int src_offset, int dst_offset, int koffset) {
  local float smem[16 + 2 * 8][16 + 2 * 8];

  int x = get_local_id(0);
  int y = get_local_id(1);
  int gx = get_global_id(0);
  int gy = get_global_id(1);

  smem[hook(14, y)][hook(13, x)] = src[hook(0, min(max(gy - 8, 0), rows - 1) * src_step + min(max(gx - 8, 0), cols - 1) + src_offset)];

  smem[hook(14, y)][hook(13, x + 16)] = src[hook(0, min(max(gy - 8, 0), rows - 1) * src_step + min(gx + 8, cols - 1) + src_offset)];

  smem[hook(14, y + 16)][hook(15, x)] = src[hook(0, min(gy + 8, rows - 1) * src_step + min(max(gx - 8, 0), cols - 1) + src_offset)];

  smem[hook(14, y + 16)][hook(15, x + 16)] = src[hook(0, min(gy + 8, rows - 1) * src_step + min(gx + 8, cols - 1) + src_offset)];

  barrier(0x01);

  if (gx < cols && gy < rows) {
    float res = 0;

    for (int i = 0; i < kHeight; ++i)
      for (int j = 0; j < kWidth; ++j)
        res += smem[hook(14, y + 8 - kHeight / 2 + i)][hook(16, x + 8 - kWidth / 2 + j)] * temp1[hook(1, i * k_step + j + koffset)];

    dst[hook(2, gy * dst_step + gx + dst_offset)] = res;
  }
}