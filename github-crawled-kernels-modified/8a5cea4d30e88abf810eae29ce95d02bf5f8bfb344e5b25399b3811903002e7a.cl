//{"dst_image":1,"src_image":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
kernel void simple_image(read_only image2d_t src_image, write_only image2d_t dst_image) {
  unsigned int offset = get_global_id(1) * 0x4000 + get_global_id(0) * 0x1000;

  int2 coord = (int2)(get_global_id(0), get_global_id(1));
  uint4 pixel = read_imageui(src_image, sampler, coord);

  pixel.x -= offset;

  write_imageui(dst_image, coord, pixel);
}