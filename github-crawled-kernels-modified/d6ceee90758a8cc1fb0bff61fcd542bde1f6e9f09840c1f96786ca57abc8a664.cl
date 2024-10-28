//{"block_hists":7,"cblock_hist_size":2,"cdescr_size":0,"cdescr_width":1,"coefs":8,"free_coef":9,"hist":13,"img_block_width":4,"img_win_width":3,"labels":11,"products":14,"smem":12,"threshold":10,"win_block_stride_x":5,"win_block_stride_y":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float reduce_smem(volatile local float* smem, int size) {
  unsigned int tid = get_local_id(0);
  float sum = smem[hook(12, tid)];

  if (size >= 512) {
    if (tid < 256)
      smem[hook(12, tid)] = sum = sum + smem[hook(12, tid + 256)];
    barrier(0x01);
  }
  if (size >= 256) {
    if (tid < 128)
      smem[hook(12, tid)] = sum = sum + smem[hook(12, tid + 128)];
    barrier(0x01);
  }
  if (size >= 128) {
    if (tid < 64)
      smem[hook(12, tid)] = sum = sum + smem[hook(12, tid + 64)];
    barrier(0x01);
  }
  if (size >= 64) {
    if (tid < 32)
      smem[hook(12, tid)] = sum = sum + smem[hook(12, tid + 32)];
    barrier(0x01);
  }
  if (size >= 32) {
    if (tid < 16)
      smem[hook(12, tid)] = sum = sum + smem[hook(12, tid + 16)];
    barrier(0x01);
  }
  if (size >= 16) {
    if (tid < 8)
      smem[hook(12, tid)] = sum = sum + smem[hook(12, tid + 8)];
    barrier(0x01);
  }
  if (size >= 8) {
    if (tid < 4)
      smem[hook(12, tid)] = sum = sum + smem[hook(12, tid + 4)];
    barrier(0x01);
  }
  if (size >= 4) {
    if (tid < 2)
      smem[hook(12, tid)] = sum = sum + smem[hook(12, tid + 2)];
    barrier(0x01);
  }
  if (size >= 2) {
    if (tid < 1)
      smem[hook(12, tid)] = sum = sum + smem[hook(12, tid + 1)];
    barrier(0x01);
  }

  return sum;
}

kernel void classify_hists_kernel(const int cdescr_size, const int cdescr_width, const int cblock_hist_size, const int img_win_width, const int img_block_width, const int win_block_stride_x, const int win_block_stride_y, global const float* block_hists, global const float* coefs, float free_coef, float threshold, global uchar* labels) {
  const int tid = get_local_id(0);
  const int gidX = get_group_id(0);
  const int gidY = get_group_id(1);

  global const float* hist = block_hists + (gidY * win_block_stride_y * img_block_width + gidX * win_block_stride_x) * cblock_hist_size;

  float product = 0.f;
  for (int i = tid; i < cdescr_size; i += 256) {
    int offset_y = i / cdescr_width;
    int offset_x = i - offset_y * cdescr_width;
    product += coefs[hook(8, i)] * hist[hook(13, offset_y * img_block_width * cblock_hist_size + offset_x)];
  }

  local float products[256];

  products[hook(14, tid)] = product;

  barrier(0x01);

  if (tid < 128)
    products[hook(14, tid)] = product = product + products[hook(14, tid + 128)];
  barrier(0x01);
  ;
  if (tid < 64)
    products[hook(14, tid)] = product = product + products[hook(14, tid + 64)];
  barrier(0x01);
  ;
  if (tid < 32)
    products[hook(14, tid)] = product = product + products[hook(14, tid + 32)];
  barrier(0x01);
  ;
  if (tid < 16)
    products[hook(14, tid)] = product = product + products[hook(14, tid + 16)];
  barrier(0x01);
  ;
  if (tid < 8)
    products[hook(14, tid)] = product = product + products[hook(14, tid + 8)];
  barrier(0x01);
  ;
  if (tid < 4)
    products[hook(14, tid)] = product = product + products[hook(14, tid + 4)];
  barrier(0x01);
  ;
  if (tid < 2)
    products[hook(14, tid)] = product = product + products[hook(14, tid + 2)];
  barrier(0x01);
  ;

  if (tid == 0) {
    products[hook(14, tid)] = product = product + products[hook(14, tid + 1)];
    labels[hook(11, gidY * img_win_width + gidX)] = (product + free_coef >= threshold);
  }
}