//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
uchar packOcclusion(const float value) {
  return clamp((int)(value * 255.0f), 0, 255);
}

float unpackOcclusion(const uchar value) {
  return clamp(value / 255.0f, 0.0f, 1.0f);
}

float4 unpackColor(const unsigned int float3) {
  return (float4)(clamp(((float3 >> 16) & 0xFF) / 255.0f, 0.0f, 1.0f), clamp(((float3 >> 8) & 0xFF) / 255.0f, 0.0f, 1.0f), clamp(((float3 >> 0) & 0xFF) / 255.0f, 0.0f, 1.0f), clamp(((float3 >> 24) & 0xFF) / 255.0f, 0.0f, 1.0f));
}

unsigned int packColor(const float4 float3) {
  return clamp((int)(float3.s3 * 255.0f), 0, 255) << 24 |

         clamp((int)(float3.s0 * 255.0f), 0, 255) << 16 | clamp((int)(float3.s1 * 255.0f), 0, 255) << 8 | clamp((int)(float3.s2 * 255.0f), 0, 255) << 0;
}

float4 multMatVec(const float16 m, const float4 v) {
  return (float4)(dot(m.s0123, v), dot(m.s4567, v), dot(m.s89AB, v), dot(m.sCDEF, v));
}

float4 getClipPosFromDepth(const int2 screenPos, const int2 screenSize, const float depth, const float16 projMatrix) {
  float3 ndcPos = (float3)((float)screenPos.x / screenSize.x, (float)screenPos.y / screenSize.y, depth) * 2.0f - 1.0f;

  const float pm32 = projMatrix.sB;
  const float pm22 = projMatrix.sA;
  const float pm23 = projMatrix.sE;

  const float clipW = pm32 / (ndcPos.z - pm22 / pm23);
  const float4 clipPos = (float4)(ndcPos * clipW, clipW);

  return clipPos;
}

float3 reflect(float3 V, float3 N) {
  return V - 2.0f * dot(V, N) * N;
}

float2 normalizePos(int2 pos, int2 size) {
  return (float2)((float)pos.x / size.x, (float)pos.y / size.y);
}

kernel void downHalfFilter(read_only image2d_t src, write_only image2d_t dst) {
  const int2 dstPos = (int2)(get_global_id(0), get_global_id(1));

  const int2 dstSize = get_image_dim(dst);
  const int2 srcSize = get_image_dim(src);

  if (dstPos.x >= dstSize.x || dstPos.y >= dstSize.y)
    return;

  const sampler_t sampler = 0 | 2 | 0x20;

  const float2 dstNormPos = normalizePos(dstPos, dstSize);
  float2 srcPos = (float2)(dstNormPos.x * srcSize.x + 1.0f, dstNormPos.y * srcSize.y + 1.0f);
  float3 srcColor = read_imagef((src), (sampler), (srcPos)).xyz;

  write_imagef(dst, dstPos, (float4)(srcColor, 1.0f));
}