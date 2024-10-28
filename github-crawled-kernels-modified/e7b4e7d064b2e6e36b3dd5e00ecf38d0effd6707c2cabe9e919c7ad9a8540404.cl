//{"dst_buffer":1,"src_image":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void texture_filter(read_only image2d_t src_image, global uchar* dst_buffer) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  int pixel = read_imageui(src_image, sampler, (int2)(x, y)).s0;

  dst_buffer[hook(1, y * get_global_size(0) + x)] = (uchar)clamp(pixel, 0, 255);
}