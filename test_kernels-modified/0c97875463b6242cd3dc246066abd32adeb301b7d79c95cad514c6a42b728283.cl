//{"base":2,"corr_size":1,"correlation":0,"mask":3,"sample_size":4,"stride":5,"sums":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void correlate(global float* correlation, const int corr_size, constant float4* base, constant float4* mask, const int sample_size, const int stride) {
  int gid = get_global_id(0) * corr_size;
  int offset_y = get_global_id(0);
  for (int y = 0; y < sample_size - offset_y; y++) {
    int mask_idx = y * stride;
    for (int offset_x = 0; offset_x < corr_size; offset_x += 4) {
      float4 sums[4];
      for (int i = 0; i < 4; i++)
        sums[hook(6, i)] = 0;
      int base_idx = (offset_y + y) * stride + offset_x;
      for (int x = 0; x < sample_size - offset_x; x++) {
        for (int i = 0; i < 4; i++)
          sums[hook(6, i)] += base[hook(2, base_idx + x + i)] * mask[hook(3, mask_idx + x)];
      }
      for (int i = 0; i < 4; i++)
        correlation[hook(0, gid + offset_x + i)] += ((sums[hook(6, i)]).x + (sums[hook(6, i)]).y + (sums[hook(6, i)]).z + (sums[hook(6, i)]).w);
    }
  }
}