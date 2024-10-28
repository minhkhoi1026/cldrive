//{"block_hists":7,"cblock_hist_size":0,"cdescr_size":2,"cdescr_width":3,"descriptor":10,"descriptors":8,"descriptors_quadstep":1,"hist":11,"img_block_width":4,"smem":9,"win_block_stride_x":5,"win_block_stride_y":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float reduce_smem(volatile local float* smem, int size) {
  unsigned int tid = get_local_id(0);
  float sum = smem[hook(9, tid)];

  if (size >= 512) {
    if (tid < 256)
      smem[hook(9, tid)] = sum = sum + smem[hook(9, tid + 256)];
    barrier(0x01);
  }
  if (size >= 256) {
    if (tid < 128)
      smem[hook(9, tid)] = sum = sum + smem[hook(9, tid + 128)];
    barrier(0x01);
  }
  if (size >= 128) {
    if (tid < 64)
      smem[hook(9, tid)] = sum = sum + smem[hook(9, tid + 64)];
    barrier(0x01);
  }
  if (size >= 64) {
    if (tid < 32)
      smem[hook(9, tid)] = sum = sum + smem[hook(9, tid + 32)];
    barrier(0x01);
  }
  if (size >= 32) {
    if (tid < 16)
      smem[hook(9, tid)] = sum = sum + smem[hook(9, tid + 16)];
    barrier(0x01);
  }
  if (size >= 16) {
    if (tid < 8)
      smem[hook(9, tid)] = sum = sum + smem[hook(9, tid + 8)];
    barrier(0x01);
  }
  if (size >= 8) {
    if (tid < 4)
      smem[hook(9, tid)] = sum = sum + smem[hook(9, tid + 4)];
    barrier(0x01);
  }
  if (size >= 4) {
    if (tid < 2)
      smem[hook(9, tid)] = sum = sum + smem[hook(9, tid + 2)];
    barrier(0x01);
  }
  if (size >= 2) {
    if (tid < 1)
      smem[hook(9, tid)] = sum = sum + smem[hook(9, tid + 1)];
    barrier(0x01);
  }

  return sum;
}

kernel void extract_descrs_by_rows_kernel(const int cblock_hist_size, const int descriptors_quadstep, const int cdescr_size, const int cdescr_width, const int img_block_width, const int win_block_stride_x, const int win_block_stride_y, global const float* block_hists, global float* descriptors) {
  int tid = get_local_id(0);
  int gidX = get_group_id(0);
  int gidY = get_group_id(1);

  global const float* hist = block_hists + (gidY * win_block_stride_y * img_block_width + gidX * win_block_stride_x) * cblock_hist_size;

  global float* descriptor = descriptors + (gidY * get_num_groups(0) + gidX) * descriptors_quadstep;

  for (int i = tid; i < cdescr_size; i += 256) {
    int offset_y = i / cdescr_width;
    int offset_x = i - offset_y * cdescr_width;
    descriptor[hook(10, i)] = hist[hook(11, offset_y * img_block_width * cblock_hist_size + offset_x)];
  }
}