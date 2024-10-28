//{"N":2,"countTable":7,"iso":8,"isoImage":4,"occupied":0,"viCount":1,"viHistogram":3,"zBias":6,"zStride":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t nearest = 0 | 2 | 0x10;
inline unsigned int makeCode(const float iso[8]) {
  return (iso[hook(8, 0)] >= 0.0f ? 0x01U : 0U) | (iso[hook(8, 1)] >= 0.0f ? 0x02U : 0U) | (iso[hook(8, 2)] >= 0.0f ? 0x04U : 0U) | (iso[hook(8, 3)] >= 0.0f ? 0x08U : 0U) | (iso[hook(8, 4)] >= 0.0f ? 0x10U : 0U) | (iso[hook(8, 5)] >= 0.0f ? 0x20U : 0U) | (iso[hook(8, 6)] >= 0.0f ? 0x40U : 0U) | (iso[hook(8, 7)] >= 0.0f ? 0x80U : 0U);
}

inline bool isValid(const float iso[8]) {
  return isfinite(iso[hook(8, 0)]) && isfinite(iso[hook(8, 1)]) && isfinite(iso[hook(8, 2)]) && isfinite(iso[hook(8, 3)]) && isfinite(iso[hook(8, 4)]) && isfinite(iso[hook(8, 5)]) && isfinite(iso[hook(8, 6)]) && isfinite(iso[hook(8, 7)]);
}
kernel void genOccupied(global uint3* restrict occupied, global uint2* restrict viCount, volatile global unsigned int* restrict N, volatile global unsigned int* restrict viHistogram, read_only image2d_t isoImage, unsigned int zStride, int zBias, constant uchar2* restrict countTable) {
  uint3 gid = (uint3)(get_global_id(0), get_global_id(1), get_global_id(2));
  unsigned int y0 = gid.y + zStride * gid.z + zBias;
  unsigned int y1 = y0 + zStride;

  float iso[8];
  iso[hook(8, 0)] = read_imagef(isoImage, nearest, (int2)(gid.x, y0)).x;
  iso[hook(8, 1)] = read_imagef(isoImage, nearest, (int2)(gid.x + 1, y0)).x;
  iso[hook(8, 2)] = read_imagef(isoImage, nearest, (int2)(gid.x, y0 + 1)).x;
  iso[hook(8, 3)] = read_imagef(isoImage, nearest, (int2)(gid.x + 1, y0 + 1)).x;
  iso[hook(8, 4)] = read_imagef(isoImage, nearest, (int2)(gid.x, y1)).x;
  iso[hook(8, 5)] = read_imagef(isoImage, nearest, (int2)(gid.x + 1, y1)).x;
  iso[hook(8, 6)] = read_imagef(isoImage, nearest, (int2)(gid.x, y1 + 1)).x;
  iso[hook(8, 7)] = read_imagef(isoImage, nearest, (int2)(gid.x + 1, y1 + 1)).x;

  unsigned int code = makeCode(iso);
  bool valid = isValid(iso);

  if (valid && code != 0 && code != 255) {
    unsigned int pos = atomic_inc(N);
    occupied[hook(0, pos)] = gid;
    uint2 vi = convert_uint2(countTable[hook(7, code)]);
    viCount[hook(1, pos)] = vi;
    atomic_add(&viHistogram[hook(3, 2 * gid.z)], vi.x);
    atomic_add(&viHistogram[hook(3, 2 * gid.z + 1)], vi.y);
  }
}