//{"invertMaxGlobalId":1,"sourceImage":0,"uImage":3,"uvMaxIndex":6,"vImage":4,"yImage":2,"yMaxIndex":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rgbToYuv(read_only image2d_t sourceImage, const float2 invertMaxGlobalId, write_only image2d_t yImage, write_only image2d_t uImage, write_only image2d_t vImage, const int2 yMaxIndex, const int2 uvMaxIndex) {
  const sampler_t sampler = 0 | 0 | 0x10;
  float2 normalizedCoord;
  float4 float3;
  float r, g, b, y, u, v;
  int2 yCoord, uvCoord;

  normalizedCoord.x = get_global_id(0) * invertMaxGlobalId.x;
  normalizedCoord.y = get_global_id(1) * invertMaxGlobalId.y;

  float3 = read_imagef(sourceImage, sampler, (int2)(get_global_id(0), get_global_id(1)));

  r = float3.x;
  g = float3.y;
  b = float3.z;

  y = clamp(0.299f * r + 0.587f * g + 0.114f * b, 0.0f, 1.0f);
  u = clamp(-0.169f * r - 0.331f * g + 0.5f * b + 0.5f, 0.0f, 1.0f);
  v = clamp(0.5f * r - 0.419f * g - 0.081f * b + 0.5f, 0.0f, 1.0f);

  yCoord = (int2)(round(yMaxIndex.x * normalizedCoord.x), round(yMaxIndex.y * normalizedCoord.y));
  uvCoord = (int2)(round(uvMaxIndex.x * normalizedCoord.x), round(uvMaxIndex.y * normalizedCoord.y));
  write_imagef(yImage, yCoord, (float4)(y, 0.0, 0.0, 1.0));
  write_imagef(uImage, uvCoord, (float4)(u, 0.0, 0.0, 1.0));
  write_imagef(vImage, uvCoord, (float4)(v, 0.0, 0.0, 1.0));
}