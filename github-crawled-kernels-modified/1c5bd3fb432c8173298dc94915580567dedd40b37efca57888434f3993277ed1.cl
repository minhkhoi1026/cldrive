//{"arg":12,"clusters":5,"height":4,"in":0,"key":13,"mapio":9,"mean":14,"out":2,"source_mean":7,"target_mean":6,"tmp":1,"var_ratio":8,"weight":15,"width":3,"xtrans":11,"xtrans[row % 6]":10}
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
  return xtrans[hook(11, row % 6)][hook(10, col % 6)];
}

float GAUSS(float center, float wings, float x) {
  const float b = -1.0f + center * 2.0f;
  const float c = (wings / 10.0f) / 2.0f;
  return exp(-(x - b) * (x - b) / (c * c));
}

typedef enum _channelmixer_output_t { CHANNEL_HUE = 0, CHANNEL_SATURATION, CHANNEL_LIGHTNESS, CHANNEL_RED, CHANNEL_GREEN, CHANNEL_BLUE, CHANNEL_GRAY, CHANNEL_SIZE } _channelmixer_output_t;

void encrypt_tea(unsigned int* arg) {
  const unsigned int key[] = {0xa341316c, 0xc8013ea4, 0xad90777d, 0x7e95761e};
  unsigned int v0 = arg[hook(12, 0)], v1 = arg[hook(12, 1)];
  unsigned int sum = 0;
  unsigned int delta = 0x9e3779b9;
  for (int i = 0; i < 8; i++) {
    sum += delta;
    v0 += ((v1 << 4) + key[hook(13, 0)]) ^ (v1 + sum) ^ ((v1 >> 5) + key[hook(13, 1)]);
    v1 += ((v0 << 4) + key[hook(13, 2)]) ^ (v0 + sum) ^ ((v0 >> 5) + key[hook(13, 3)]);
  }
  arg[hook(12, 0)] = v0;
  arg[hook(12, 1)] = v1;
}

float tpdf(unsigned int urandom) {
  float frandom = (float)urandom / 0xFFFFFFFFu;

  return (frandom < 0.5f ? (sqrt(2.0f * frandom) - 1.0f) : (1.0f - sqrt(2.0f * (1.0f - frandom))));
}

void get_clusters(const float4 col, const int n, global float2* mean, float* weight) {
  float mdist = 0x1.fffffep127f;
  for (int k = 0; k < n; k++) {
    const float dist2 = (col.y - mean[hook(14, k)].x) * (col.y - mean[hook(14, k)].x) + (col.z - mean[hook(14, k)].y) * (col.z - mean[hook(14, k)].y);
    weight[hook(15, k)] = dist2 > 1.0e-6f ? 1.0f / dist2 : -1.0f;
    if (dist2 < mdist)
      mdist = dist2;
  }
  if (mdist < 1.0e-6f)
    for (int k = 0; k < n; k++)
      weight[hook(15, k)] = weight[hook(15, k)] < 0.0f ? 1.0f : 0.0f;
  float sum = 0.0f;
  for (int k = 0; k < n; k++)
    sum += weight[hook(15, k)];
  if (sum > 0.0f)
    for (int k = 0; k < n; k++)
      weight[hook(15, k)] /= sum;
}

kernel void colormapping_mapping(read_only image2d_t in, read_only image2d_t tmp, write_only image2d_t out, const int width, const int height, const int clusters, global float2* target_mean, global float2* source_mean, global float2* var_ratio, global int* mapio) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  float4 ipixel = read_imagef(in, sampleri, (int2)(x, y));
  float dL = read_imagef(tmp, sampleri, (int2)(x, y)).x;
  float weight[5];
  float4 opixel = (float4)0.0f;

  opixel.x = 2.0f * (dL - 50.0f) + ipixel.x;
  opixel.x = clamp(opixel.x, 0.0f, 100.0f);

  get_clusters(ipixel, clusters, target_mean, weight);

  for (int c = 0; c < clusters; c++) {
    opixel.y += weight[hook(15, c)] * ((ipixel.y - target_mean[hook(6, c)].x) * var_ratio[hook(8, c)].x + source_mean[hook(7, mapio[chook(9, c))].x);
    opixel.z += weight[hook(15, c)] * ((ipixel.z - target_mean[hook(6, c)].y) * var_ratio[hook(8, c)].y + source_mean[hook(7, mapio[chook(9, c))].y);
  }
  opixel.w = ipixel.w;

  write_imagef(out, (int2)(x, y), opixel);
}