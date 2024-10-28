//{"a":12,"ca":6,"ctable":5,"height":3,"in":0,"la":8,"ltable":7,"out":1,"saturation":4,"unbound":9,"width":2,"xtrans":11,"xtrans[row % 6]":10}
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
float lookup_unbounded(read_only image2d_t lut, const float x, global float* a) {
  if (a[hook(12, 0)] >= 0.0f) {
    if (x < 1.0f) {
      const int xi = clamp((int)(x * 0x10000ul), 0, 0xffff);
      const int2 p = (int2)((xi & 0xff), (xi >> 8));
      return read_imagef(lut, sampleri, p).x;
    } else
      return a[hook(12, 1)] * native_powr(x * a[hook(12, 0)], a[hook(12, 2)]);
  } else
    return x;
}

kernel void lowpass_mix(read_only image2d_t in, write_only image2d_t out, unsigned int width, unsigned int height, const float saturation, read_only image2d_t ctable, global float* ca, read_only image2d_t ltable, global float* la, const int unbound) {
  const unsigned int x = get_global_id(0);
  const unsigned int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  float4 i = read_imagef(in, sampleri, (int2)(x, y));
  float4 o;

  const float4 Labmin = unbound ? (float4)(-(__builtin_inff()), -(__builtin_inff()), -(__builtin_inff()), -(__builtin_inff())) : (float4)(0.0f, -128.0f, -128.0f, 0.0f);
  const float4 Labmax = unbound ? (float4)((__builtin_inff()), (__builtin_inff()), (__builtin_inff()), (__builtin_inff())) : (float4)(100.0f, 128.0f, 128.0f, 1.0f);

  o.x = lookup_unbounded(ctable, i.x / 100.0f, ca);
  o.x = lookup_unbounded(ltable, o.x / 100.0f, la);
  o.y = clamp(i.y * saturation, Labmin.y, Labmax.y);
  o.z = clamp(i.z * saturation, Labmin.z, Labmax.z);
  o.w = i.w;

  write_imagef(out, (int2)(x, y), o);
}