//{"center":4,"ev":6,"height":3,"in":0,"out":1,"width":2,"wings":5,"xtrans":8,"xtrans[row % 6]":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampleri = 0 | 2 | 0x10;
constant sampler_t samplerf = 0 | 2 | 0x20;
constant sampler_t samplerc = 0 | 4 | 0x10;
int FC(const int row, const int col, const unsigned int filters) {
  return filters >> ((((row) << 1 & 14) + ((col)&1)) << 1) & 3;
}

int FCxtrans(const int row, const int col, global const unsigned char (*const xtrans)[6]) {
  return xtrans[hook(8, row % 6)][hook(7, col % 6)];
}

float GAUSS(float center, float wings, float x) {
  const float b = -1.0f + center * 2.0f;
  const float c = (wings / 10.0f) / 2.0f;
  return exp(-(x - b) * (x - b) / (c * c));
}

kernel void relight(read_only image2d_t in, write_only image2d_t out, const int width, const int height, const float center, const float wings, const float ev) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  float4 pixel = read_imagef(in, sampleri, (int2)(x, y));

  const float lightness = pixel.x / 100.0f;
  const float value = -1.0f + (lightness * 2.0f);
  float gauss = GAUSS(center, wings, value);

  if (isnan(gauss) || isinf(gauss))
    gauss = 0.0f;

  float relight = 1.0f / exp2(-ev * clamp(gauss, 0.0f, 1.0f));

  if (isnan(relight) || isinf(relight))
    relight = 1.0f;

  pixel.x = 100.0f * clamp(lightness * relight, 0.0f, 1.0f);

  write_imagef(out, (int2)(x, y), pixel);
}