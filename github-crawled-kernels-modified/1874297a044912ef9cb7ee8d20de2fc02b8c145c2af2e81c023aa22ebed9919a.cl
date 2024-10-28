//{"arg":7,"height":3,"in":0,"key":8,"out":1,"parameters":4,"width":2,"xtrans":6,"xtrans[row % 6]":5}
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
  return xtrans[hook(6, row % 6)][hook(5, col % 6)];
}

float GAUSS(float center, float wings, float x) {
  const float b = -1.0f + center * 2.0f;
  const float c = (wings / 10.0f) / 2.0f;
  return exp(-(x - b) * (x - b) / (c * c));
}

typedef enum _channelmixer_output_t { CHANNEL_HUE = 0, CHANNEL_SATURATION, CHANNEL_LIGHTNESS, CHANNEL_RED, CHANNEL_GREEN, CHANNEL_BLUE, CHANNEL_GRAY, CHANNEL_SIZE } _channelmixer_output_t;

void encrypt_tea(unsigned int* arg) {
  const unsigned int key[] = {0xa341316c, 0xc8013ea4, 0xad90777d, 0x7e95761e};
  unsigned int v0 = arg[hook(7, 0)], v1 = arg[hook(7, 1)];
  unsigned int sum = 0;
  unsigned int delta = 0x9e3779b9;
  for (int i = 0; i < 8; i++) {
    sum += delta;
    v0 += ((v1 << 4) + key[hook(8, 0)]) ^ (v1 + sum) ^ ((v1 >> 5) + key[hook(8, 1)]);
    v1 += ((v0 << 4) + key[hook(8, 2)]) ^ (v0 + sum) ^ ((v0 >> 5) + key[hook(8, 3)]);
  }
  arg[hook(7, 0)] = v0;
  arg[hook(7, 1)] = v1;
}

float tpdf(unsigned int urandom) {
  float frandom = (float)urandom / 0xFFFFFFFFu;

  return (frandom < 0.5f ? (sqrt(2.0f * frandom) - 1.0f) : (1.0f - sqrt(2.0f * (1.0f - frandom))));
}

kernel void global_tonemap_reinhard(read_only image2d_t in, write_only image2d_t out, const int width, const int height, const float4 parameters) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  float4 pixel = read_imagef(in, sampleri, (int2)(x, y));

  float l = pixel.x * 0.01f;

  pixel.x = 100.0f * (l / (1.0f + l));

  write_imagef(out, (int2)(x, y), pixel);
}