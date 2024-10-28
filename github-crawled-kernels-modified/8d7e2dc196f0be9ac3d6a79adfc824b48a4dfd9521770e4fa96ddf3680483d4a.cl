//{"iso":3,"srcImage":0,"trgImage":1,"trgOffset":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t nearest = 0 | 2 | 0x10;
inline unsigned int makeCode(const float iso[8]) {
  return (iso[hook(3, 0)] >= 0.0f ? 0x01U : 0U) | (iso[hook(3, 1)] >= 0.0f ? 0x02U : 0U) | (iso[hook(3, 2)] >= 0.0f ? 0x04U : 0U) | (iso[hook(3, 3)] >= 0.0f ? 0x08U : 0U) | (iso[hook(3, 4)] >= 0.0f ? 0x10U : 0U) | (iso[hook(3, 5)] >= 0.0f ? 0x20U : 0U) | (iso[hook(3, 6)] >= 0.0f ? 0x40U : 0U) | (iso[hook(3, 7)] >= 0.0f ? 0x80U : 0U);
}

inline bool isValid(const float iso[8]) {
  return isfinite(iso[hook(3, 0)]) && isfinite(iso[hook(3, 1)]) && isfinite(iso[hook(3, 2)]) && isfinite(iso[hook(3, 3)]) && isfinite(iso[hook(3, 4)]) && isfinite(iso[hook(3, 5)]) && isfinite(iso[hook(3, 6)]) && isfinite(iso[hook(3, 7)]);
}
inline float3 interp(float iso0, float iso1, uint3 cell, uint3 offset0, uint3 offset1) {
  float inv = 1.0f / (iso0 - iso1);
  uint3 delta = offset1 - offset0;
  float3 lcoord = fma(iso0 * inv, convert_float3(delta), convert_float3(cell + offset0));
  return lcoord;
}
ulong computeKey(uint3 coords, uint3 top) {
  ulong key = ((ulong)coords.z << (2 * 21)) | ((ulong)coords.y << (21)) | ((ulong)coords.x);
  if (any(coords.xy == 0U) || any(coords == top))
    key |= (1UL << 63);
  return key;
}
kernel void copySlice(read_only image2d_t srcImage, write_only image2d_t trgImage, int2 trgOffset) {
  int2 srcAddr = (int2)(get_global_id(0), get_global_id(1));
  float4 value = read_imagef(srcImage, nearest, srcAddr);
  int2 trgAddr = srcAddr + trgOffset;
  write_imagef(trgImage, trgAddr, value);
}