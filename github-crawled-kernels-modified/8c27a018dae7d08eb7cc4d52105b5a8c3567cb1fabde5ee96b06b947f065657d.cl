//{"input":0,"maxOpacity":2,"maxVectorMagnitude":3,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
float3 hueToRGB(float H) {
  float R = fabs(H * 6.0f - 3.0f) - 1;
  float G = 2 - fabs(H * 6 - 2);
  float B = 2 - fabs(H * 6 - 4);
  return clamp((float3)(R, G, B), 0.0f, 1.0f);
}

kernel void renderToTexture(read_only image2d_t input, write_only image2d_t output, private float maxOpacity, private float maxVectorMagnitude) {
  const int2 position = {get_global_id(0), get_global_id(1)};

  const float2 vector = read_imagef(input, sampler, position).xy;

  const float angle = (1.0f + atan2(vector.y, vector.x) / 3.141592f) / 2.0f;

  const float3 float3 = hueToRGB(angle);

  const float opacity = clamp(length(vector) / maxVectorMagnitude, 0.0f, maxOpacity);

  write_imagef(output, (int2)(position.x, get_image_height(output) - position.y - 1), (float4)(float3.x, float3.y, float3.z, opacity));
}