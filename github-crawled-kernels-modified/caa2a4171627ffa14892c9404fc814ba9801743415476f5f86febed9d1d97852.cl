//{"P":5,"U4_in":0,"U4_out":1,"buffer":7,"height":3,"q":4,"sharpness":6,"width":2,"xtrans":9,"xtrans[row % 6]":8}
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
  return xtrans[hook(9, row % 6)][hook(8, col % 6)];
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

kernel void nlmeans_vert(global float* U4_in, global float* U4_out, const int width, const int height, const int2 q, const int P, const float sharpness, local float* buffer) {
  const int lid = get_local_id(1);
  const int lsz = get_local_size(1);
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int gidx = mad24(min(y, height - 1), width, min(x, width - 1));

  if (x < width) {
    buffer[hook(7, P + lid)] = U4_in[hook(0, gidx)];

    for (int n = 0; n <= P / lsz; n++) {
      const int l = mad24(n, lsz, lid + 1);
      if (l > P)
        continue;
      int yy = mad24((int)get_group_id(1), lsz, -l);
      yy = max(yy, 0);
      buffer[hook(7, P - l)] = U4_in[hook(0, mad24(yy, width, x))];
    }

    for (int n = 0; n <= P / lsz; n++) {
      const int r = mad24(n, lsz, lsz - lid);
      if (r > P)
        continue;
      int yy = mad24((int)get_group_id(1), lsz, lsz - 1 + r);
      yy = min(yy, height - 1);
      buffer[hook(7, P + lsz - 1 + r)] = U4_in[hook(0, mad24(yy, width, x))];
    }
  }

  barrier(0x01);

  if (x >= width || y >= height)
    return;

  buffer += lid + P;

  float distacc = 0.0f;
  for (int pj = -P; pj <= P; pj++) {
    distacc += buffer[hook(7, pj)];
  }

  distacc = gh(distacc, sharpness);

  U4_out[hook(1, gidx)] = distacc;
}