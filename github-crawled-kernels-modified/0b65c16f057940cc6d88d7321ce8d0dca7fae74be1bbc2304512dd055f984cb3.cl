//{"imageIn":0,"level":4,"level0":2,"level1":3,"resultIn":1,"resultOut":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clCombine(read_only image2d_t imageIn, read_only image2d_t resultIn, read_only image2d_t level0, read_only image2d_t level1, int level, write_only image2d_t resultOut) {
  const sampler_t sampler = 1 | 0x20 | 2;

  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int w = get_global_size(0);
  const int h = get_global_size(1);

  float2 pixel = (float2)((x + 0.5) / w, (y + 0.5) / h);
  float4 l0 = read_imagef(level0, sampler, pixel);
  float4 l1 = read_imagef(level1, sampler, pixel);

  float lum0 = l0.x / 100.0;
  float lum1 = l1.x / 100.0;

  float scale = min(0.35, 0.35 * 1.6 * (level));
  float lumX = 0.18 * pow(2.0f, 8.0f) / scale;
  float activity = (lum0 - lum1) / (lumX + lum0);

  if (fabs(activity) > 0.00005) {
    float4 result = read_imagef(resultIn, sampler, pixel);
    if (result.x == 0) {
      float4 image = read_imagef(imageIn, sampler, pixel);
      image.x = image.x / (100.0f * (1.0f + l0.x));
      write_imagef(resultOut, (int2)(x, y), image);
    }
  }
}