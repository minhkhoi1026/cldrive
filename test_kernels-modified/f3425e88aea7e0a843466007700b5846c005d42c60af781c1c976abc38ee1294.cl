//{"firstExternal":3,"inKeys":6,"inVertices":5,"indexRemap":2,"iso":9,"keyOffset":8,"minExternalKey":7,"outKeys":1,"outVertices":0,"vertexUnique":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t nearest = 0 | 2 | 0x10;
inline unsigned int makeCode(const float iso[8]) {
  return (iso[hook(9, 0)] >= 0.0f ? 0x01U : 0U) | (iso[hook(9, 1)] >= 0.0f ? 0x02U : 0U) | (iso[hook(9, 2)] >= 0.0f ? 0x04U : 0U) | (iso[hook(9, 3)] >= 0.0f ? 0x08U : 0U) | (iso[hook(9, 4)] >= 0.0f ? 0x10U : 0U) | (iso[hook(9, 5)] >= 0.0f ? 0x20U : 0U) | (iso[hook(9, 6)] >= 0.0f ? 0x40U : 0U) | (iso[hook(9, 7)] >= 0.0f ? 0x80U : 0U);
}

inline bool isValid(const float iso[8]) {
  return isfinite(iso[hook(9, 0)]) && isfinite(iso[hook(9, 1)]) && isfinite(iso[hook(9, 2)]) && isfinite(iso[hook(9, 3)]) && isfinite(iso[hook(9, 4)]) && isfinite(iso[hook(9, 5)]) && isfinite(iso[hook(9, 6)]) && isfinite(iso[hook(9, 7)]);
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
kernel void compactVertices(global float* restrict outVertices, global ulong* restrict outKeys, global unsigned int* restrict indexRemap, global unsigned int* firstExternal, global const unsigned int* restrict vertexUnique, global const float4* restrict inVertices, global const ulong* restrict inKeys, ulong minExternalKey, ulong keyOffset) {
  const unsigned int gid = get_global_id(0);
  const unsigned int u = vertexUnique[hook(4, gid)];
  const float4 v = inVertices[hook(5, gid)];
  const ulong key = inKeys[hook(6, gid)];
  const ulong nextKey = inKeys[hook(6, gid + 1)];
  bool ext = key >= minExternalKey;
  if (key != nextKey) {
    vstore3(v.xyz, u, outVertices);
    if (ext) {
      outKeys[hook(1, u)] = (key & ((1UL << 63) - 1)) + keyOffset;
      if (u == 0)
        *firstExternal = 0;
    } else if (nextKey >= minExternalKey)
      *firstExternal = u + 1;
  }
  unsigned int originalIndex = __builtin_astype((v.w), unsigned int);
  indexRemap[hook(2, originalIndex)] = u;
}