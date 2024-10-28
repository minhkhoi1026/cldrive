//{"col":2,"num_rows":0,"row_offset":1,"sdata":6,"val":3,"x":4,"y":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float ReadVecFromImg(int ind, read_only image2d_t img, const sampler_t smp) {
  if (ind < 0)
    return 0;

  int imgPos = ind;
  int2 coords;
  coords.x = imgPos & 0x1fff;
  coords.y = imgPos >> 13;

  float4 temp = read_imagef(img, smp, coords);
  return temp.x;
}

kernel void s_kernel_test2(const int num_rows, global const int* row_offset, global const int* col, global const float* val, read_only image2d_t x, global float* y, local volatile float* sdata) {
  const int idx = get_global_id(0);
  const int warp_id = idx / 32;
  const int thread_lane = idx & (32 - 1);
  const int num_warps = get_global_size(0) / 32;

  const sampler_t smp = 0 | 2 | 0x10;

  for (int row = warp_id; row < num_rows; row += num_warps) {
    const int row_start = row_offset[hook(1, row)];
    const int row_end = row_offset[hook(1, row + 1)];

    float sum = 0;

    for (int j = row_start + thread_lane; j < row_end; j += 32)
      sum += val[hook(3, j)] * ReadVecFromImg(col[hook(2, j)], x, smp);

    const int i = get_local_id(0);

    sdata[hook(6, i)] = sum;
    sdata[hook(6, i)] = sum += sdata[hook(6, i + 16)];
    sdata[hook(6, i)] = sum += sdata[hook(6, i + 8)];
    sdata[hook(6, i)] = sum += sdata[hook(6, i + 4)];
    sdata[hook(6, i)] = sum += sdata[hook(6, i + 2)];
    sdata[hook(6, i)] = sum += sdata[hook(6, i + 1)];

    if (thread_lane == 0)
      y[hook(5, row)] = sum;
  }
}