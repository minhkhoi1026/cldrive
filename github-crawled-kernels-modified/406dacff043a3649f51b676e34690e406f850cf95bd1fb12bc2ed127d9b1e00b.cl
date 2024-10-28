//{"dstImg":1,"srcImg":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void grayscale(read_only image2d_t srcImg, write_only image2d_t dstImg) {
  const sampler_t smp = 0 | 2 | 0x10;
  int2 coord = (int2)(get_global_id(0), get_global_id(1));
  uint4 bgra = read_imageui(srcImg, smp, coord);

  float4 bgrafloat = convert_float4(bgra) / 255.0f;

  float luminance = sqrt(0.241f * bgrafloat.z * bgrafloat.z + 0.691f * bgrafloat.y * bgrafloat.y + 0.068f * bgrafloat.x * bgrafloat.x);
  bgra.x = bgra.y = bgra.z = (unsigned int)(luminance * 255.0f);
  bgra.w = 255;

  write_imageui(dstImg, coord, bgra);
}