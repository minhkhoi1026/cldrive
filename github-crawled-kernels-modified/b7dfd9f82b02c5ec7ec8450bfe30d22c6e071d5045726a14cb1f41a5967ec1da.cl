//{"imageIn":0,"imageOut":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 2 | 0x10;
kernel void edges(read_only image2d_t imageIn, write_only image2d_t imageOut) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  if (x >= get_image_width(imageIn) || y >= get_image_height(imageIn))
    return;

  uint4 gx = read_imageui(imageIn, sampler, (int2)(x + 1, y - 1)) + 2 * read_imageui(imageIn, sampler, (int2)(x + 1, y)) + read_imageui(imageIn, sampler, (int2)(x + 1, y + 1)) - read_imageui(imageIn, sampler, (int2)(x - 1, y - 1)) - 2 * read_imageui(imageIn, sampler, (int2)(x - 1, y)) - read_imageui(imageIn, sampler, (int2)(x - 1, y + 1));

  uint4 gy = read_imageui(imageIn, sampler, (int2)(x - 1, y + 1)) + 2 * read_imageui(imageIn, sampler, (int2)(x, y + 1)) + read_imageui(imageIn, sampler, (int2)(x + 1, y + 1)) - read_imageui(imageIn, sampler, (int2)(x - 1, y - 1)) - 2 * read_imageui(imageIn, sampler, (int2)(x, y - 1)) - read_imageui(imageIn, sampler, (int2)(x + 1, y - 1));

  uint4 pixel = convert_uint4(sqrt(convert_float4(gx * gx + gy * gy)));
  pixel = clamp(pixel, (uint4)(0), (uint4)(255));

  pixel.s3 = 255;
  write_imageui(imageOut, (int2)(x, y), pixel);
}