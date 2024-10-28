//{"arg":9,"equalization":4,"height":3,"in":0,"key":10,"mean":11,"out":1,"source_ihist":6,"target_hist":5,"weight":12,"width":2,"xtrans":8,"xtrans[row % 6]":7}
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

typedef enum _channelmixer_output_t { CHANNEL_HUE = 0, CHANNEL_SATURATION, CHANNEL_LIGHTNESS, CHANNEL_RED, CHANNEL_GREEN, CHANNEL_BLUE, CHANNEL_GRAY, CHANNEL_SIZE } _channelmixer_output_t;

void encrypt_tea(unsigned int* arg) {
  const unsigned int key[] = {0xa341316c, 0xc8013ea4, 0xad90777d, 0x7e95761e};
  unsigned int v0 = arg[hook(9, 0)], v1 = arg[hook(9, 1)];
  unsigned int sum = 0;
  unsigned int delta = 0x9e3779b9;
  for (int i = 0; i < 8; i++) {
    sum += delta;
    v0 += ((v1 << 4) + key[hook(10, 0)]) ^ (v1 + sum) ^ ((v1 >> 5) + key[hook(10, 1)]);
    v1 += ((v0 << 4) + key[hook(10, 2)]) ^ (v0 + sum) ^ ((v0 >> 5) + key[hook(10, 3)]);
  }
  arg[hook(9, 0)] = v0;
  arg[hook(9, 1)] = v1;
}

float tpdf(unsigned int urandom) {
  float frandom = (float)urandom / 0xFFFFFFFFu;

  return (frandom < 0.5f ? (sqrt(2.0f * frandom) - 1.0f) : (1.0f - sqrt(2.0f * (1.0f - frandom))));
}

void get_clusters(const float4 col, const int n, global float2* mean, float* weight) {
  float mdist = 0x1.fffffep127f;
  for (int k = 0; k < n; k++) {
    const float dist2 = (col.y - mean[hook(11, k)].x) * (col.y - mean[hook(11, k)].x) + (col.z - mean[hook(11, k)].y) * (col.z - mean[hook(11, k)].y);
    weight[hook(12, k)] = dist2 > 1.0e-6f ? 1.0f / dist2 : -1.0f;
    if (dist2 < mdist)
      mdist = dist2;
  }
  if (mdist < 1.0e-6f)
    for (int k = 0; k < n; k++)
      weight[hook(12, k)] = weight[hook(12, k)] < 0.0f ? 1.0f : 0.0f;
  float sum = 0.0f;
  for (int k = 0; k < n; k++)
    sum += weight[hook(12, k)];
  if (sum > 0.0f)
    for (int k = 0; k < n; k++)
      weight[hook(12, k)] /= sum;
}

kernel void colormapping_histogram(read_only image2d_t in, write_only image2d_t out, const int width, const int height, const float equalization, global int* target_hist, global float* source_ihist) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  float L = read_imagef(in, sampleri, (int2)(x, y)).x;

  float dL = 0.5f * ((L * (1.0f - equalization) + source_ihist[hook(6, target_hishook(5, (int)clamp((1 << 11) * L / 100.F, 0.F, (float)(1 << 11) - 1.F)))] * equalization) - L) + 50.0f;
  dL = clamp(dL, 0.0f, 100.0f);

  write_imagef(out, (int2)(x, y), (float4)(dL, 0.0f, 0.0f, 0.0f));
}