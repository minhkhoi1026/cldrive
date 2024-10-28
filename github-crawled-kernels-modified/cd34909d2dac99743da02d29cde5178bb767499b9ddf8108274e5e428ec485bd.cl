//{"dstImg":1,"srcImg":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void toGray(read_only image2d_t srcImg, write_only image2d_t dstImg) {
  const sampler_t smp = 0 | 2 | 0x10;

  int2 coord = (int2)(get_global_id(0), get_global_id(1));

  uint4 rgba = read_imageui(srcImg, smp, coord);

  float4 rgbafloat = convert_float4(rgba) / 255.0f;

  float luminance = sqrt(0.241f * rgbafloat.z * rgbafloat.z + 0.691f * rgbafloat.y * rgbafloat.y + 0.068f * rgbafloat.x * rgbafloat.x);

  rgba.x = rgba.y = rgba.z = (unsigned int)(luminance * 255.0f);
  rgba.w = 255;

  write_imageui(dstImg, coord, rgba);
}