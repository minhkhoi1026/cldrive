//{"block_hist_size":1,"block_hists":3,"hist":7,"img_block_width":2,"nthreads":0,"smem":6,"squares":5,"threshold":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float reduce_smem(volatile local float* smem, int size) {
  unsigned int tid = get_local_id(0);
  float sum = smem[hook(6, tid)];

  if (size >= 512) {
    if (tid < 256)
      smem[hook(6, tid)] = sum = sum + smem[hook(6, tid + 256)];
    barrier(0x01);
  }
  if (size >= 256) {
    if (tid < 128)
      smem[hook(6, tid)] = sum = sum + smem[hook(6, tid + 128)];
    barrier(0x01);
  }
  if (size >= 128) {
    if (tid < 64)
      smem[hook(6, tid)] = sum = sum + smem[hook(6, tid + 64)];
    barrier(0x01);
  }
  if (tid < 32) {
    if (size >= 64)
      smem[hook(6, tid)] = sum = sum + smem[hook(6, tid + 32)];
  }
  barrier(0x01);
  if (tid < 16) {
    if (size >= 32)
      smem[hook(6, tid)] = sum = sum + smem[hook(6, tid + 16)];
    if (size >= 16)
      smem[hook(6, tid)] = sum = sum + smem[hook(6, tid + 8)];
    if (size >= 8)
      smem[hook(6, tid)] = sum = sum + smem[hook(6, tid + 4)];
    if (size >= 4)
      smem[hook(6, tid)] = sum = sum + smem[hook(6, tid + 2)];
    if (size >= 2)
      smem[hook(6, tid)] = sum = sum + smem[hook(6, tid + 1)];
  }

  return sum;
}

kernel void normalize_hists_kernel(const int nthreads, const int block_hist_size, const int img_block_width, global float* block_hists, const float threshold, local float* squares) {
  const int tid = get_local_id(0);
  const int gidX = get_group_id(0);
  const int gidY = get_group_id(1);

  global float* hist = block_hists + (gidY * img_block_width + gidX) * block_hist_size + tid;

  float elem = 0.f;
  if (tid < block_hist_size)
    elem = hist[hook(7, 0)];

  squares[hook(5, tid)] = elem * elem;

  barrier(0x01);
  float sum = reduce_smem(squares, nthreads);

  float scale = 1.0f / (sqrt(sum) + 0.1f * block_hist_size);
  elem = min(elem * scale, threshold);

  barrier(0x01);
  squares[hook(5, tid)] = elem * elem;

  barrier(0x01);
  sum = reduce_smem(squares, nthreads);
  scale = 1.0f / (sqrt(sum) + 1e-3f);

  if (tid < block_hist_size)
    hist[hook(7, 0)] = elem * scale;
}