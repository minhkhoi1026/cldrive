//{"base":2,"corr_size":1,"correlation":0,"l_base":7,"l_mask":8,"mask":3,"sample_size":4,"stride":5,"sums":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((required_work_group_size(64, 1, 1))) kernel void correlate(global float8* correlation, const int corr_size, constant float4* base, constant float4* mask, const int sample_size, const int stride) {
  float4 l_base[((1 * 8) + 10)], l_mask[((1 * 8) + 10)];
  float4 sums[(1 * 8)];
  for (int i = 0; i < (1 * 8); i++)
    sums[hook(6, i)] = 0;
  int gid = get_global_id(0);
  int offset_y = gid * (1 * 8) / corr_size;
  int offset_x = gid * (1 * 8) - (offset_y * corr_size);
  for (int y = 0; y < sample_size - offset_y; y++) {
    int mask_idx = y * stride - offset_x;
    int mi = max(mask_idx, 0);
    int base_idx = (offset_y + y) * stride;
    for (int x = offset_x % 10; x < sample_size; x += 10) {
      if (x < offset_x) {
        for (int i = 0; i < 8; i++) {
          l_base[hook(7, i)] = base[hook(2, base_idx + x + i)];
          l_mask[hook(8, i)] = mask[hook(3, mi + x + i)];
        }
      } else {
        for (int i = 0; i < ((1 * 8) + 10); i++) {
          l_base[hook(7, i)] = base[hook(2, base_idx + x + i)];
          l_mask[hook(8, i)] = mask[hook(3, mask_idx + x + i)];
        }
        for (int i = 0; i < 10; i++)
          for (int j = 0; j < (1 * 8); j++)
            sums[hook(6, j)] += l_base[hook(7, i + j)] * l_mask[hook(8, i)];
      }
    }
  }
  for (int i = 0; i < 1; i++)
    correlation[hook(0, gid * 1 + i)] = (float8)(((sums[hook(6, i * 8 + 0)]).x + (sums[hook(6, i * 8 + 0)]).y + (sums[hook(6, i * 8 + 0)]).z + (sums[hook(6, i * 8 + 0)]).w), ((sums[hook(6, i * 8 + 1)]).x + (sums[hook(6, i * 8 + 1)]).y + (sums[hook(6, i * 8 + 1)]).z + (sums[hook(6, i * 8 + 1)]).w), ((sums[hook(6, i * 8 + 2)]).x + (sums[hook(6, i * 8 + 2)]).y + (sums[hook(6, i * 8 + 2)]).z + (sums[hook(6, i * 8 + 2)]).w), ((sums[hook(6, i * 8 + 3)]).x + (sums[hook(6, i * 8 + 3)]).y + (sums[hook(6, i * 8 + 3)]).z + (sums[hook(6, i * 8 + 3)]).w), ((sums[hook(6, i * 8 + 4)]).x + (sums[hook(6, i * 8 + 4)]).y + (sums[hook(6, i * 8 + 4)]).z + (sums[hook(6, i * 8 + 4)]).w), ((sums[hook(6, i * 8 + 5)]).x + (sums[hook(6, i * 8 + 5)]).y + (sums[hook(6, i * 8 + 5)]).z + (sums[hook(6, i * 8 + 5)]).w), ((sums[hook(6, i * 8 + 6)]).x + (sums[hook(6, i * 8 + 6)]).y + (sums[hook(6, i * 8 + 6)]).z + (sums[hook(6, i * 8 + 6)]).w), ((sums[hook(6, i * 8 + 7)]).x + (sums[hook(6, i * 8 + 7)]).y + (sums[hook(6, i * 8 + 7)]).z + (sums[hook(6, i * 8 + 7)]).w));
}