//{"baseline_mm":3,"depth_map":0,"disparity_map":1,"focal_length":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
kernel void disparityToDepth(write_only image2d_t depth_map, read_only image2d_t disparity_map, const int focal_length, const int baseline_mm) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  unsigned int disp = read_imageui(disparity_map, sampler, (int2)(x, y)).x;
  unsigned int depth = (focal_length * baseline_mm) / disp;
  unsigned int write_pixel = depth;

  write_imageui(depth_map, (int2)(x, y), write_pixel);
}