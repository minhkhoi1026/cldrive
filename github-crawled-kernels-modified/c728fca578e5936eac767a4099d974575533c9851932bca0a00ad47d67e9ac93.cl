//{"hist":1,"img_input":0,"nchannels":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglCl2dPartialHistogram(read_only image2d_t img_input, global unsigned int* hist, int nchannels) {
  const sampler_t smp = 0 | 2 | 0x10;

  unsigned int posx = get_global_id(0);
  unsigned int height = get_image_height(img_input);

  for (unsigned int y = 0; y < 256; y++) {
    for (unsigned int z = 0; z < nchannels; z++) {
      hist[hook(1, posx * 256 * nchannels + y * nchannels + z)] = 0;
    }
  }

  for (unsigned int y = 0; y < height; y++) {
    float4 pixel = read_imagef(img_input, smp, (float2)(posx, y));
    for (unsigned int ch = 0; ch < nchannels; ch++) {
      uchar c;
      if (ch == 0)
        c = convert_uchar_sat(pixel.x * 255.0f);
      if (ch == 1)
        c = convert_uchar_sat(pixel.y * 255.0f);
      if (ch == 2)
        c = convert_uchar_sat(pixel.z * 255.0f);
      if (ch == 3)
        c = convert_uchar_sat(pixel.w * 255.0f);
      atomic_inc(&hist[hook(1, (posx * 256 * nchannels) + (c * nchannels) + ch)]);
    }
  }
}