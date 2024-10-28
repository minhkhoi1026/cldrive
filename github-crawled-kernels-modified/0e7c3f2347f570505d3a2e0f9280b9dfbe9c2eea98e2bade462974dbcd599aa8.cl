//{"base":2,"corr_size":1,"correlation":0,"mask":3,"sample_size":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void correlate(global float* correlation, const int corr_size, constant float4* base, constant float4* mask, const int sample_size) {
  int gid = get_global_id(0);
  int offset_y = gid / corr_size;
  int offset_x = gid % corr_size;
  float4 sum = 0;
  for (int y = 0; y < sample_size - offset_y; y++) {
    int mask_idx = y * sample_size;
    int base_idx = (offset_y + y) * sample_size + offset_x;
    for (int x = 0; x < sample_size - offset_x; x++) {
      sum += base[hook(2, base_idx + x)] * mask[hook(3, mask_idx + x)];
    }
  }
  correlation[hook(0, gid)] = sum.x + sum.y + sum.z + sum.w;
}