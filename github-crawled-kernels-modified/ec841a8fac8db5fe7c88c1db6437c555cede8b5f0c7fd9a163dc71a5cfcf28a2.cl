//{"arg":8,"coeff_Lab":14,"height":3,"in":0,"key":9,"mean":10,"num_patches":4,"out":1,"params":5,"poly_Lab":12,"source_Lab":13,"weight":11,"width":2,"xtrans":7,"xtrans[row % 6]":6}
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

void encrypt_tea(unsigned int* arg) {
  const unsigned int key[] = {0xa341316c, 0xc8013ea4, 0xad90777d, 0x7e95761e};
  unsigned int v0 = arg[hook(8, 0)], v1 = arg[hook(8, 1)];
  unsigned int sum = 0;
  unsigned int delta = 0x9e3779b9;
  for (int i = 0; i < 8; i++) {
    sum += delta;
    v0 += ((v1 << 4) + key[hook(9, 0)]) ^ (v1 + sum) ^ ((v1 >> 5) + key[hook(9, 1)]);
    v1 += ((v0 << 4) + key[hook(9, 2)]) ^ (v0 + sum) ^ ((v0 >> 5) + key[hook(9, 3)]);
  }
  arg[hook(8, 0)] = v0;
  arg[hook(8, 1)] = v1;
}

float tpdf(unsigned int urandom) {
  float frandom = (float)urandom / 0xFFFFFFFFu;

  return (frandom < 0.5f ? (sqrt(2.0f * frandom) - 1.0f) : (1.0f - sqrt(2.0f * (1.0f - frandom))));
}

void get_clusters(const float4 col, const int n, global float2* mean, float* weight) {
  float mdist = 0x1.fffffep127f;
  for (int k = 0; k < n; k++) {
    const float dist2 = (col.y - mean[hook(10, k)].x) * (col.y - mean[hook(10, k)].x) + (col.z - mean[hook(10, k)].y) * (col.z - mean[hook(10, k)].y);
    weight[hook(11, k)] = dist2 > 1.0e-6f ? 1.0f / dist2 : -1.0f;
    if (dist2 < mdist)
      mdist = dist2;
  }
  if (mdist < 1.0e-6f)
    for (int k = 0; k < n; k++)
      weight[hook(11, k)] = weight[hook(11, k)] < 0.0f ? 1.0f : 0.0f;
  float sum = 0.0f;
  for (int k = 0; k < n; k++)
    sum += weight[hook(11, k)];
  if (sum > 0.0f)
    for (int k = 0; k < n; k++)
      weight[hook(11, k)] /= sum;
}

float fastlog2(float x) {
  union {
    float f;
    unsigned int i;
  } vx = {x};
  union {
    unsigned int i;
    float f;
  } mx = {(vx.i & 0x007FFFFF) | 0x3f000000};

  float y = vx.i;

  y *= 1.1920928955078125e-7f;

  return y - 124.22551499f - 1.498030302f * mx.f - 1.72587999f / (0.3520887068f + mx.f);
}

float fastlog(float x) {
  return 0.69314718f * fastlog2(x);
}

float thinplate(const float4 x, const float4 y) {
  const float r2 = (x.x - y.x) * (x.x - y.x) + (x.y - y.y) * (x.y - y.y) + (x.z - y.z) * (x.z - y.z);

  return 0.5f * r2 * fastlog(max(1e-8f, r2));
}

kernel void colorchecker(read_only image2d_t in, write_only image2d_t out, const int width, const int height, const int num_patches, global float4* params) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  global float4* source_Lab = params;
  global float4* coeff_Lab = params + num_patches;
  global float4* poly_Lab = params + 2 * num_patches;

  float4 ipixel = read_imagef(in, sampleri, (int2)(x, y));

  const float w = ipixel.w;

  float4 opixel = poly_Lab[hook(12, 0)] + poly_Lab[hook(12, 1)] * ipixel.x + poly_Lab[hook(12, 2)] * ipixel.y + poly_Lab[hook(12, 3)] * ipixel.z;

  for (int k = 0; k < num_patches; k++) {
    const float phi = thinplate(ipixel, source_Lab[hook(13, k)]);
    opixel += coeff_Lab[hook(14, k)] * phi;
  }

  opixel.w = w;

  write_imagef(out, (int2)(x, y), opixel);
}