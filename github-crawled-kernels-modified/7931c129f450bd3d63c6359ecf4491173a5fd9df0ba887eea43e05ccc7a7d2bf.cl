//{"a":16,"compress":7,"flags":10,"height":4,"highlights":6,"highlights_ccorrect":9,"in":0,"low_approximation":12,"mask":1,"out":2,"shadows":5,"shadows_ccorrect":8,"unbound_mask":11,"whitepoint":13,"width":3,"xtrans":15,"xtrans[row % 6]":14}
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
float lookup_unbounded(read_only image2d_t lut, const float x, global float* a) {
  if (a[hook(16, 0)] >= 0.0f) {
    if (x < 1.0f) {
      const int xi = clamp((int)(x * 0x10000ul), 0, 0xffff);
      const int2 p = (int2)((xi & 0xff), (xi >> 8));
      return read_imagef(lut, sampleri, p).x;
    } else
      return a[hook(16, 1)] * native_powr(x * a[hook(16, 0)], a[hook(16, 2)]);
  } else
    return x;
}

float4 overlay(const float4 in_a, const float4 in_b, const float opacity, const float transform, const float ccorrect, const int4 unbound, const float low_approximation) {
  const float4 scale = (float4)(100.0f, 128.0f, 128.0f, 1.0f);
  const float lmin = 0.0f;
  const float lmax = 1.0f;
  const float halfmax = 0.5f;
  const float doublemax = 2.0f;

  float4 a = in_a / scale;
  float4 b = in_b / scale;

  float opacity2 = opacity * opacity;

  while (opacity2 > 0.0f) {
    float la = unbound.x ? a.x : clamp(a.x, lmin, lmax);
    float lb = (b.x - halfmax) * sign(opacity) * sign(lmax - la) + halfmax;
    lb = unbound.w ? lb : clamp(lb, lmin, lmax);
    float lref = copysign(fabs(la) > low_approximation ? 1.0f / fabs(la) : 1.0f / low_approximation, la);
    float href = copysign(fabs(1.0f - la) > low_approximation ? 1.0f / fabs(1.0f - la) : 1.0f / low_approximation, 1.0f - la);

    float chunk = opacity2 > 1.0f ? 1.0f : opacity2;
    float optrans = chunk * transform;
    opacity2 -= 1.0f;

    a.x = la * (1.0f - optrans) + (la > halfmax ? lmax - (lmax - doublemax * (la - halfmax)) * (lmax - lb) : doublemax * la * lb) * optrans;
    a.x = unbound.x ? a.x : clamp(a.x, lmin, lmax);

    a.y = a.y * (1.0f - optrans) + (a.y + b.y) * (a.x * lref * ccorrect + (1.0f - a.x) * href * (1.0f - ccorrect)) * optrans;
    a.y = unbound.y ? a.y : clamp(a.y, -1.0f, 1.0f);

    a.z = a.z * (1.0f - optrans) + (a.z + b.z) * (a.x * lref * ccorrect + (1.0f - a.x) * href * (1.0f - ccorrect)) * optrans;
    a.z = unbound.z ? a.z : clamp(a.z, -1.0f, 1.0f);
  }

  return a * scale;
}
kernel void shadows_highlights_mix(read_only image2d_t in, read_only image2d_t mask, write_only image2d_t out, unsigned int width, unsigned int height, const float shadows, const float highlights, const float compress, const float shadows_ccorrect, const float highlights_ccorrect, const unsigned int flags, const int unbound_mask, const float low_approximation, const float whitepoint) {
  const unsigned int x = get_global_id(0);
  const unsigned int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  float4 io = read_imagef(in, sampleri, (int2)(x, y));
  float w = io.w;
  float4 m = (float4)0.0f;
  float xform;
  int4 unbound;

  m.x = 100.0f - read_imagef(mask, sampleri, (int2)(x, y)).x;

  io.x = io.x > 0.0f ? io.x / whitepoint : io.x;
  m.x = m.x > 0.0f ? m.x / whitepoint : m.x;

  xform = clamp(1.0f - 0.01f * m.x / (1.0f - compress), 0.0f, 1.0f);
  unbound = (int4)(flags & (1 << 3), flags & (2 << 3), flags & (4 << 3), unbound_mask);
  io = overlay(io, m, -highlights, xform, 1.0f - highlights_ccorrect, unbound, low_approximation);

  xform = clamp(0.01f * m.x / (1.0f - compress) - compress / (1.0f - compress), 0.0f, 1.0f);
  unbound = (int4)(flags & 1, flags & 2, flags & 4, unbound_mask);
  io = overlay(io, m, shadows, xform, shadows_ccorrect, unbound, low_approximation);

  io.w = w;
  write_imagef(out, (int2)(x, y), io);
}