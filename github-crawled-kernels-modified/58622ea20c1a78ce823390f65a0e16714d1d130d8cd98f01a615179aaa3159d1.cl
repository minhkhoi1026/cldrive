//{"arg":15,"brightness":9,"dither":11,"dscale":7,"expt":6,"fscale":8,"height":3,"in":0,"key":16,"out":1,"roi_center_scaled":5,"saturation":10,"scale":4,"tea_state":17,"unbound":12,"width":2,"xtrans":14,"xtrans[row % 6]":13}
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
  return xtrans[hook(14, row % 6)][hook(13, col % 6)];
}

float GAUSS(float center, float wings, float x) {
  const float b = -1.0f + center * 2.0f;
  const float c = (wings / 10.0f) / 2.0f;
  return exp(-(x - b) * (x - b) / (c * c));
}

typedef enum _channelmixer_output_t { CHANNEL_HUE = 0, CHANNEL_SATURATION, CHANNEL_LIGHTNESS, CHANNEL_RED, CHANNEL_GREEN, CHANNEL_BLUE, CHANNEL_GRAY, CHANNEL_SIZE } _channelmixer_output_t;

void encrypt_tea(unsigned int* arg) {
  const unsigned int key[] = {0xa341316c, 0xc8013ea4, 0xad90777d, 0x7e95761e};
  unsigned int v0 = arg[hook(15, 0)], v1 = arg[hook(15, 1)];
  unsigned int sum = 0;
  unsigned int delta = 0x9e3779b9;
  for (int i = 0; i < 8; i++) {
    sum += delta;
    v0 += ((v1 << 4) + key[hook(16, 0)]) ^ (v1 + sum) ^ ((v1 >> 5) + key[hook(16, 1)]);
    v1 += ((v0 << 4) + key[hook(16, 2)]) ^ (v0 + sum) ^ ((v0 >> 5) + key[hook(16, 3)]);
  }
  arg[hook(15, 0)] = v0;
  arg[hook(15, 1)] = v1;
}

float tpdf(unsigned int urandom) {
  float frandom = (float)urandom / (float)0xFFFFFFFFu;

  return (frandom < 0.5f ? (sqrt(2.0f * frandom) - 1.0f) : (1.0f - sqrt(2.0f * (1.0f - frandom))));
}

kernel void vignette(read_only image2d_t in, write_only image2d_t out, const int width, const int height, const float2 scale, const float2 roi_center_scaled, const float2 expt, const float dscale, const float fscale, const float brightness, const float saturation, const float dither, const int unbound) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  unsigned int tea_state[2] = {mad24(y, width, x), 0};
  encrypt_tea(tea_state);

  const float2 pv = fabs((float2)(x, y) * scale - roi_center_scaled);

  const float cplen = pow(pow(pv.x, expt.x) + pow(pv.y, expt.x), expt.y);

  float weight = 0.0f;
  float dith = 0.0f;

  if (cplen >= dscale) {
    weight = ((cplen - dscale) / fscale);

    dith = (weight <= 1.0f && weight >= 0.0f) ? dither * tpdf(tea_state[hook(17, 0)]) : 0.0f;

    weight = weight >= 1.0f ? 1.0f : (weight <= 0.0f ? 0.0f : 0.5f - cos(3.14159265358979323846264338327950288f * weight) / 2.0f);
  }

  float4 pixel = read_imagef(in, sampleri, (int2)(x, y));

  if (weight > 0.0f) {
    float falloff = brightness < 0.0f ? 1.0f + (weight * brightness) : weight * brightness;

    pixel.xyz = (brightness < 0.0f ? pixel * falloff + dith : pixel + falloff + dith).xyz;

    pixel.xyz = unbound ? pixel.xyz : clamp(pixel, (float4)0.0f, (float4)1.0f).xyz;

    float mv = (pixel.x + pixel.y + pixel.z) / 3.0f;
    float wss = weight * saturation;

    pixel.xyz = (pixel - (mv - pixel) * wss).xyz,

    pixel.xyz = unbound ? pixel.xyz : clamp(pixel, (float4)0.0f, (float4)1.0f).xyz;
  }

  write_imagef(out, (int2)(x, y), pixel);
}