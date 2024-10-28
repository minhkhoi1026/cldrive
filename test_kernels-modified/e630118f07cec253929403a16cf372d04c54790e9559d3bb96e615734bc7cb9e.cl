//{"cells":4,"dataTable":7,"gridOffset":11,"indices":2,"iso":14,"isoImage":5,"keyTable":8,"lvertices":13,"lverts":15,"startTable":6,"top":12,"vertexKeys":1,"vertices":0,"viStart":3,"zBias":10,"zStride":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t nearest = 0 | 2 | 0x10;
inline unsigned int makeCode(const float iso[8]) {
  return (iso[hook(14, 0)] >= 0.0f ? 0x01U : 0U) | (iso[hook(14, 1)] >= 0.0f ? 0x02U : 0U) | (iso[hook(14, 2)] >= 0.0f ? 0x04U : 0U) | (iso[hook(14, 3)] >= 0.0f ? 0x08U : 0U) | (iso[hook(14, 4)] >= 0.0f ? 0x10U : 0U) | (iso[hook(14, 5)] >= 0.0f ? 0x20U : 0U) | (iso[hook(14, 6)] >= 0.0f ? 0x40U : 0U) | (iso[hook(14, 7)] >= 0.0f ? 0x80U : 0U);
}

inline bool isValid(const float iso[8]) {
  return isfinite(iso[hook(14, 0)]) && isfinite(iso[hook(14, 1)]) && isfinite(iso[hook(14, 2)]) && isfinite(iso[hook(14, 3)]) && isfinite(iso[hook(14, 4)]) && isfinite(iso[hook(14, 5)]) && isfinite(iso[hook(14, 6)]) && isfinite(iso[hook(14, 7)]);
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
kernel void generateElements(global float4* vertices, global ulong* vertexKeys, global unsigned int* indices, global const uint2* restrict viStart, global const uint3* restrict cells, read_only image2d_t isoImage, global const ushort2* restrict startTable, global const uchar* restrict dataTable, global const uint3* restrict keyTable, unsigned int zStride, int zBias, uint3 gridOffset, uint3 top, local float3* lvertices) {
  const unsigned int gid = get_global_id(0);
  const unsigned int lid = get_local_id(0);
  uint3 cell = cells[hook(4, gid)];
  const unsigned int y0 = cell.z * zStride + zBias + cell.y;
  const unsigned int y1 = y0 + zStride;
  const uint3 globalCell = cell + gridOffset;
  local float3* lverts = lvertices + 19 * lid;

  float iso[8];
  iso[hook(14, 0)] = read_imagef(isoImage, nearest, (int2)(cell.x, y0)).x;
  iso[hook(14, 1)] = read_imagef(isoImage, nearest, (int2)(cell.x + 1, y0)).x;
  iso[hook(14, 2)] = read_imagef(isoImage, nearest, (int2)(cell.x, y0 + 1)).x;
  iso[hook(14, 3)] = read_imagef(isoImage, nearest, (int2)(cell.x + 1, y0 + 1)).x;
  iso[hook(14, 4)] = read_imagef(isoImage, nearest, (int2)(cell.x, y1)).x;
  iso[hook(14, 5)] = read_imagef(isoImage, nearest, (int2)(cell.x + 1, y1)).x;
  iso[hook(14, 6)] = read_imagef(isoImage, nearest, (int2)(cell.x, y1 + 1)).x;
  iso[hook(14, 7)] = read_imagef(isoImage, nearest, (int2)(cell.x + 1, y1 + 1)).x;

  lverts[hook(15, 0)] = interp(iso[hook(14, 0)], iso[hook(14, 1)], globalCell, (uint3)(0 & 1, (0 >> 1) & 1, (0 >> 2) & 1), (uint3)(1 & 1, (1 >> 1) & 1, (1 >> 2) & 1));
  lverts[hook(15, 1)] = interp(iso[hook(14, 0)], iso[hook(14, 2)], globalCell, (uint3)(0 & 1, (0 >> 1) & 1, (0 >> 2) & 1), (uint3)(2 & 1, (2 >> 1) & 1, (2 >> 2) & 1));
  lverts[hook(15, 2)] = interp(iso[hook(14, 0)], iso[hook(14, 3)], globalCell, (uint3)(0 & 1, (0 >> 1) & 1, (0 >> 2) & 1), (uint3)(3 & 1, (3 >> 1) & 1, (3 >> 2) & 1));
  lverts[hook(15, 3)] = interp(iso[hook(14, 1)], iso[hook(14, 3)], globalCell, (uint3)(1 & 1, (1 >> 1) & 1, (1 >> 2) & 1), (uint3)(3 & 1, (3 >> 1) & 1, (3 >> 2) & 1));
  lverts[hook(15, 4)] = interp(iso[hook(14, 2)], iso[hook(14, 3)], globalCell, (uint3)(2 & 1, (2 >> 1) & 1, (2 >> 2) & 1), (uint3)(3 & 1, (3 >> 1) & 1, (3 >> 2) & 1));
  lverts[hook(15, 5)] = interp(iso[hook(14, 0)], iso[hook(14, 4)], globalCell, (uint3)(0 & 1, (0 >> 1) & 1, (0 >> 2) & 1), (uint3)(4 & 1, (4 >> 1) & 1, (4 >> 2) & 1));
  lverts[hook(15, 6)] = interp(iso[hook(14, 0)], iso[hook(14, 5)], globalCell, (uint3)(0 & 1, (0 >> 1) & 1, (0 >> 2) & 1), (uint3)(5 & 1, (5 >> 1) & 1, (5 >> 2) & 1));
  lverts[hook(15, 7)] = interp(iso[hook(14, 1)], iso[hook(14, 5)], globalCell, (uint3)(1 & 1, (1 >> 1) & 1, (1 >> 2) & 1), (uint3)(5 & 1, (5 >> 1) & 1, (5 >> 2) & 1));
  lverts[hook(15, 8)] = interp(iso[hook(14, 4)], iso[hook(14, 5)], globalCell, (uint3)(4 & 1, (4 >> 1) & 1, (4 >> 2) & 1), (uint3)(5 & 1, (5 >> 1) & 1, (5 >> 2) & 1));
  lverts[hook(15, 9)] = interp(iso[hook(14, 0)], iso[hook(14, 6)], globalCell, (uint3)(0 & 1, (0 >> 1) & 1, (0 >> 2) & 1), (uint3)(6 & 1, (6 >> 1) & 1, (6 >> 2) & 1));
  lverts[hook(15, 10)] = interp(iso[hook(14, 2)], iso[hook(14, 6)], globalCell, (uint3)(2 & 1, (2 >> 1) & 1, (2 >> 2) & 1), (uint3)(6 & 1, (6 >> 1) & 1, (6 >> 2) & 1));
  lverts[hook(15, 11)] = interp(iso[hook(14, 4)], iso[hook(14, 6)], globalCell, (uint3)(4 & 1, (4 >> 1) & 1, (4 >> 2) & 1), (uint3)(6 & 1, (6 >> 1) & 1, (6 >> 2) & 1));
  lverts[hook(15, 12)] = interp(iso[hook(14, 0)], iso[hook(14, 7)], globalCell, (uint3)(0 & 1, (0 >> 1) & 1, (0 >> 2) & 1), (uint3)(7 & 1, (7 >> 1) & 1, (7 >> 2) & 1));
  lverts[hook(15, 13)] = interp(iso[hook(14, 1)], iso[hook(14, 7)], globalCell, (uint3)(1 & 1, (1 >> 1) & 1, (1 >> 2) & 1), (uint3)(7 & 1, (7 >> 1) & 1, (7 >> 2) & 1));
  lverts[hook(15, 14)] = interp(iso[hook(14, 2)], iso[hook(14, 7)], globalCell, (uint3)(2 & 1, (2 >> 1) & 1, (2 >> 2) & 1), (uint3)(7 & 1, (7 >> 1) & 1, (7 >> 2) & 1));
  lverts[hook(15, 15)] = interp(iso[hook(14, 3)], iso[hook(14, 7)], globalCell, (uint3)(3 & 1, (3 >> 1) & 1, (3 >> 2) & 1), (uint3)(7 & 1, (7 >> 1) & 1, (7 >> 2) & 1));
  lverts[hook(15, 16)] = interp(iso[hook(14, 4)], iso[hook(14, 7)], globalCell, (uint3)(4 & 1, (4 >> 1) & 1, (4 >> 2) & 1), (uint3)(7 & 1, (7 >> 1) & 1, (7 >> 2) & 1));
  lverts[hook(15, 17)] = interp(iso[hook(14, 5)], iso[hook(14, 7)], globalCell, (uint3)(5 & 1, (5 >> 1) & 1, (5 >> 2) & 1), (uint3)(7 & 1, (7 >> 1) & 1, (7 >> 2) & 1));
  lverts[hook(15, 18)] = interp(iso[hook(14, 6)], iso[hook(14, 7)], globalCell, (uint3)(6 & 1, (6 >> 1) & 1, (6 >> 2) & 1), (uint3)(7 & 1, (7 >> 1) & 1, (7 >> 2) & 1));

  unsigned int code = makeCode(iso);
  uint2 viNext = viStart[hook(3, gid)];
  unsigned int vNext = viNext.s0;
  unsigned int iNext = viNext.s1;

  ushort2 start = startTable[hook(6, code)];
  ushort2 end = startTable[hook(6, code + 1)];

  for (unsigned int i = 0; i < end.x - start.x; i++) {
    float4 vertex;
    vertex.xyz = lverts[hook(15, dataTable[shook(7, start.x + i))];
    vertex.w = __builtin_astype((vNext + i), float);
    vertices[hook(0, vNext + i)] = vertex;
    vertexKeys[hook(1, vNext + i)] = computeKey(2 * cell + keyTable[hook(8, start.x + i)], top);
  }
  for (unsigned int i = 0; i < end.y - start.y; i++) {
    indices[hook(2, iNext + i)] = vNext + dataTable[hook(7, start.y + i)];
  }
}