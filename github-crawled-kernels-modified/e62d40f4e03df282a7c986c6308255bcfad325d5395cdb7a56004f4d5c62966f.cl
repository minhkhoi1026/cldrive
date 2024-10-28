//{"block_hists":8,"cblock_hist_size":0,"cdescr_size":2,"cnblocks_win_x":3,"cnblocks_win_y":4,"descriptor":11,"descriptors":9,"descriptors_quadstep":1,"hist":12,"img_block_width":5,"smem":10,"win_block_stride_x":6,"win_block_stride_y":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float reduce_smem(volatile local float* smem, int size) {
  unsigned int tid = get_local_id(0);
  float sum = smem[hook(10, tid)];

  if (size >= 512) {
    if (tid < 256)
      smem[hook(10, tid)] = sum = sum + smem[hook(10, tid + 256)];
    barrier(0x01);
  }
  if (size >= 256) {
    if (tid < 128)
      smem[hook(10, tid)] = sum = sum + smem[hook(10, tid + 128)];
    barrier(0x01);
  }
  if (size >= 128) {
    if (tid < 64)
      smem[hook(10, tid)] = sum = sum + smem[hook(10, tid + 64)];
    barrier(0x01);
  }
  if (size >= 64) {
    if (tid < 32)
      smem[hook(10, tid)] = sum = sum + smem[hook(10, tid + 32)];
    barrier(0x01);
  }
  if (size >= 32) {
    if (tid < 16)
      smem[hook(10, tid)] = sum = sum + smem[hook(10, tid + 16)];
    barrier(0x01);
  }
  if (size >= 16) {
    if (tid < 8)
      smem[hook(10, tid)] = sum = sum + smem[hook(10, tid + 8)];
    barrier(0x01);
  }
  if (size >= 8) {
    if (tid < 4)
      smem[hook(10, tid)] = sum = sum + smem[hook(10, tid + 4)];
    barrier(0x01);
  }
  if (size >= 4) {
    if (tid < 2)
      smem[hook(10, tid)] = sum = sum + smem[hook(10, tid + 2)];
    barrier(0x01);
  }
  if (size >= 2) {
    if (tid < 1)
      smem[hook(10, tid)] = sum = sum + smem[hook(10, tid + 1)];
    barrier(0x01);
  }

  return sum;
}

kernel void extract_descrs_by_cols_kernel(const int cblock_hist_size, const int descriptors_quadstep, const int cdescr_size, const int cnblocks_win_x, const int cnblocks_win_y, const int img_block_width, const int win_block_stride_x, const int win_block_stride_y, global const float* block_hists, global float* descriptors) {
  int tid = get_local_id(0);
  int gidX = get_group_id(0);
  int gidY = get_group_id(1);

  global const float* hist = block_hists + (gidY * win_block_stride_y * img_block_width + gidX * win_block_stride_x) * cblock_hist_size;

  global float* descriptor = descriptors + (gidY * get_num_groups(0) + gidX) * descriptors_quadstep;

  for (int i = tid; i < cdescr_size; i += 256) {
    int block_idx = i / cblock_hist_size;
    int idx_in_block = i - block_idx * cblock_hist_size;

    int y = block_idx / cnblocks_win_x;
    int x = block_idx - y * cnblocks_win_x;

    descriptor[hook(11, (x * cnblocks_win_y + y) * cblock_hist_size + idx_in_block)] = hist[hook(12, (y * img_block_width + x) * cblock_hist_size + idx_in_block)];
  }
}