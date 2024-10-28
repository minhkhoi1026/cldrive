//{"indexRemap":1,"indices":0,"iso":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t nearest = 0 | 2 | 0x10;
inline unsigned int makeCode(const float iso[8]) {
  return (iso[hook(2, 0)] >= 0.0f ? 0x01U : 0U) | (iso[hook(2, 1)] >= 0.0f ? 0x02U : 0U) | (iso[hook(2, 2)] >= 0.0f ? 0x04U : 0U) | (iso[hook(2, 3)] >= 0.0f ? 0x08U : 0U) | (iso[hook(2, 4)] >= 0.0f ? 0x10U : 0U) | (iso[hook(2, 5)] >= 0.0f ? 0x20U : 0U) | (iso[hook(2, 6)] >= 0.0f ? 0x40U : 0U) | (iso[hook(2, 7)] >= 0.0f ? 0x80U : 0U);
}

inline bool isValid(const float iso[8]) {
  return isfinite(iso[hook(2, 0)]) && isfinite(iso[hook(2, 1)]) && isfinite(iso[hook(2, 2)]) && isfinite(iso[hook(2, 3)]) && isfinite(iso[hook(2, 4)]) && isfinite(iso[hook(2, 5)]) && isfinite(iso[hook(2, 6)]) && isfinite(iso[hook(2, 7)]);
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
kernel void reindex(global unsigned int* indices, global const unsigned int* restrict indexRemap) {
  const unsigned int gid = get_global_id(0);
  indices[hook(0, gid)] = indexRemap[hook(1, indices[ghook(0, gid))];
}