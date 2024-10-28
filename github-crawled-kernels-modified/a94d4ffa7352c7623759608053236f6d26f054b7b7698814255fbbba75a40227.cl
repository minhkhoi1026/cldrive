//{"centerX":2,"centerY":3,"effect":5,"input":0,"output":1,"r":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0x10 | 0 | 2;
kernel void filter(read_only image2d_t input, write_only image2d_t output, double centerX, double centerY, double r, double effect) {
  const int2 size = get_image_dim(input);
  int2 coord = (int2)(get_global_id(0), get_global_id(1));
  int2 center = (int2)((int)centerX, (int)centerY);
  float2 coord_center = convert_float2(coord - center);
  float radius = r / 2.0f;
  float strength = (float)effect;
  float dist = length(convert_float2(coord_center));

  if (dist < radius) {
    float percent = dist / radius;
    if (strength > 0.0f) {
      coord_center *= mix(1.0f, smoothstep(0.0f, radius / dist, percent), strength * 0.75f);
    } else {
      coord_center *= mix(1.0f, pow(percent, 1.0f + strength * 0.75f) * radius / dist, 1.0f - percent);
    }
  }
  coord_center += convert_float2(center);
  float4 float3 = read_imagef(input, sampler, convert_int2(coord_center));
  write_imagef(output, convert_int2(coord), float3);
}