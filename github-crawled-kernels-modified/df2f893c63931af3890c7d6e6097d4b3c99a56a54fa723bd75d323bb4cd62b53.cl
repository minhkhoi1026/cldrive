//{"Labmax":12,"Labmin":13,"a0":4,"a1":5,"a2":6,"a3":7,"b1":8,"b2":9,"coefn":11,"coefp":10,"height":3,"in":0,"out":1,"width":2,"xtrans":15,"xtrans[row % 6]":14}
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
  return xtrans[hook(15, row % 6)][hook(14, col % 6)];
}
kernel void gaussian_column_4c(global float4* in, global float4* out, unsigned int width, unsigned int height, const float a0, const float a1, const float a2, const float a3, const float b1, const float b2, const float coefp, const float coefn, const float4 Labmax, const float4 Labmin) {
  const unsigned int x = get_global_id(0);

  if (x >= width)
    return;

  float4 xp = (float4)0.0f;
  float4 yb = (float4)0.0f;
  float4 yp = (float4)0.0f;
  float4 xc = (float4)0.0f;
  float4 yc = (float4)0.0f;
  float4 xn = (float4)0.0f;
  float4 xa = (float4)0.0f;
  float4 yn = (float4)0.0f;
  float4 ya = (float4)0.0f;

  xp = clamp(in[hook(0, x)], Labmin, Labmax);
  yb = xp * coefp;
  yp = yb;

  for (int y = 0; y < height; y++) {
    const int idx = mad24((unsigned int)y, width, x);

    xc = clamp(in[hook(0, idx)], Labmin, Labmax);
    yc = (a0 * xc) + (a1 * xp) - (b1 * yp) - (b2 * yb);

    xp = xc;
    yb = yp;
    yp = yc;

    out[hook(1, idx)] = yc;
  }

  xn = clamp(in[hook(0, mad24(height - 1, width, x))], Labmin, Labmax);
  xa = xn;
  yn = xn * coefn;
  ya = yn;

  for (int y = height - 1; y > -1; y--) {
    const int idx = mad24((unsigned int)y, width, x);

    xc = clamp(in[hook(0, idx)], Labmin, Labmax);
    yc = (a2 * xn) + (a3 * xa) - (b1 * yn) - (b2 * ya);

    xa = xn;
    xn = xc;
    ya = yn;
    yn = yc;

    out[hook(1, idx)] += yc;
  }
}