//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_box_blur_image(read_only image2d_t src, write_only image2d_t dst) {
  const sampler_t sampler = 0 | 2 | 0x10;
  const int2 coord = (int2)(get_global_id(0), get_global_id(1));
  int2 offset;
  uint4 sum = 0;

  for (offset.y = -1; offset.y <= 1; offset.y++) {
    for (offset.x = -1; offset.x <= 1; offset.x++) {
      sum += read_imageui(src, sampler, coord + offset);
    }
  }

  uint4 result = sum / 9;

  write_imageui(dst, coord, result);
}