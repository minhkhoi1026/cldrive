//{"height":2,"out":0,"width":1,"xtrans":4,"xtrans[row % 6]":3}
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
  return xtrans[hook(4, row % 6)][hook(3, col % 6)];
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

kernel void nlmeans_init(global float4* out, const int width, const int height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int gidx = mad24(y, width, x);

  if (x >= width || y >= height)
    return;

  out[hook(0, gidx)] = (float4)0.0f;
}