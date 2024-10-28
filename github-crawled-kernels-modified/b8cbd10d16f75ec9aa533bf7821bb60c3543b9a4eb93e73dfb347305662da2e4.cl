//{"bias":5,"height":3,"in":0,"out":1,"strength":4,"width":2,"xtrans":7,"xtrans[row % 6]":6}
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
  return xtrans[hook(7, row % 6)][hook(6, col % 6)];
}

float GAUSS(float center, float wings, float x) {
  const float b = -1.0f + center * 2.0f;
  const float c = (wings / 10.0f) / 2.0f;
  return exp(-(x - b) * (x - b) / (c * c));
}

typedef enum _channelmixer_output_t { CHANNEL_HUE = 0, CHANNEL_SATURATION, CHANNEL_LIGHTNESS, CHANNEL_RED, CHANNEL_GREEN, CHANNEL_BLUE, CHANNEL_GRAY, CHANNEL_SIZE } _channelmixer_output_t;

kernel void velvia(read_only image2d_t in, write_only image2d_t out, const int width, const int height, const float strength, const float bias) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  float4 pixel = read_imagef(in, sampleri, (int2)(x, y));

  float pmax = fmax(pixel.x, fmax(pixel.y, pixel.z));
  float pmin = fmin(pixel.x, fmin(pixel.y, pixel.z));
  float plum = (pmax + pmin) / 2.0f;
  float psat = (plum <= 0.5f) ? (pmax - pmin) / (1e-5f + pmax + pmin) : (pmax - pmin) / (1e-5f + fmax(0.0f, 2.0f - pmax - pmin));

  float pweight = clamp(((1.0f - (1.5f * psat)) + ((1.0f + (fabs(plum - 0.5f) * 2.0f)) * (1.0f - bias))) / (1.0f + (1.0f - bias)), 0.0f, 1.0f);
  float saturation = strength * pweight;

  float4 opixel;

  opixel.x = clamp(pixel.x + saturation * (pixel.x - 0.5f * (pixel.y + pixel.z)), 0.0f, 1.0f);
  opixel.y = clamp(pixel.y + saturation * (pixel.y - 0.5f * (pixel.z + pixel.x)), 0.0f, 1.0f);
  opixel.z = clamp(pixel.z + saturation * (pixel.z - 0.5f * (pixel.x + pixel.y)), 0.0f, 1.0f);
  opixel.w = pixel.w;

  write_imagef(out, (int2)(x, y), opixel);
}