//{"U4":1,"height":3,"in":0,"nC2":6,"nL2":5,"q":4,"width":2,"xtrans":8,"xtrans[row % 6]":7}
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

kernel void nlmeans_dist(read_only image2d_t in, global float* U4, const int width, const int height, const int2 q, const float nL2, const float nC2) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int gidx = mad24(y, width, x);
  const float4 norm2 = (float4)(nL2, nC2, nC2, 1.0f);

  if (x >= width || y >= height)
    return;

  int xpq = x + q.x;
  int ypq = y + q.y;

  xpq *= (x + q.x < width && x + q.x >= 0) ? 1 : 0;
  ypq *= (y + q.y < height && y + q.y >= 0) ? 1 : 0;

  float4 p1 = read_imagef(in, sampleri, (int2)(x, y));
  float4 p2 = read_imagef(in, sampleri, (int2)(xpq, ypq));
  float4 tmp = (p1 - p2) * (p1 - p2) * norm2;
  float dist = tmp.x + tmp.y + tmp.z;

  dist *= (x + q.x < width && x + q.x >= 0 && y + q.y < height && y + q.y >= 0) ? 1.0f : 0.0f;

  U4[hook(1, gidx)] = dist;
}