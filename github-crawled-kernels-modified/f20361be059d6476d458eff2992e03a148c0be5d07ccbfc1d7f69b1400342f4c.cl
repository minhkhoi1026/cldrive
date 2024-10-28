//{"U2":1,"U4":2,"height":4,"in":0,"q":5,"width":3,"xtrans":7,"xtrans[row % 6]":6}
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
float fast_mexp2f(const float x) {
  const float i1 = (float)0x3f800000u;
  const float i2 = (float)0x3f000000u;
  const float k0 = i1 + x * (i2 - i1);
  union {
    float f;
    unsigned int i;
  } k;
  k.i = (k0 >= (float)0x800000u) ? k0 : 0;
  return k.f;
}

float gh(const float f, const float sharpness) {
  return fast_mexp2f(f * sharpness);
}

float ddirac(const int2 q) {
  return ((q.x || q.y) ? 1.0f : 0.0f);
}

kernel void nlmeans_accu(read_only image2d_t in, global float4* U2, global float* U4, const int width, const int height, const int2 q) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int gidx = mad24(y, width, x);

  if (x >= width || y >= height)
    return;

  int wpq = 1;
  int wmq = 1;

  wpq *= (x + q.x < width) ? 1 : 0;
  wmq *= (x - q.x < width) ? 1 : 0;
  wpq *= (x + q.x >= 0) ? 1 : 0;
  wmq *= (x - q.x >= 0) ? 1 : 0;

  wpq *= (y + q.y >= 0) ? 1 : 0;
  wmq *= (y - q.y >= 0) ? 1 : 0;
  wpq *= (y + q.y < height) ? 1 : 0;
  wmq *= (y - q.y < height) ? 1 : 0;

  float4 u1_pq = wpq ? read_imagef(in, sampleri, (int2)(x, y) + q) : (float4)0.0f;
  float4 u1_mq = wmq ? read_imagef(in, sampleri, (int2)(x, y) - q) : (float4)0.0f;

  float u4 = U4[hook(2, gidx)];
  float u4_mq = U4[hook(2, mad24(clamp(y - q.y, 0, height - 1), width, clamp(x - q.x, 0, width - 1)))];

  float u4_mq_dd = u4_mq * ddirac(q);

  float4 accu = (u4 * u1_pq) + (u4_mq_dd * u1_mq);
  accu.w = (wpq * u4 + wmq * u4_mq_dd);

  U2[hook(1, gidx)] += accu;
}