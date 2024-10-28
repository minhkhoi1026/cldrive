//{"colour":1,"target":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 1 | 4 | 0x20;
kernel void fill(write_only image2d_t target, float4 colour) {
  size_t x = get_global_offset(0) + get_global_id(0);
  size_t y = get_global_offset(1) + get_global_id(1);

  int2 pixel_pos = (int2)(x, y);

  write_imagef(target, pixel_pos, colour);
}