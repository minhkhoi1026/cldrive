//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float luminosity(float4 col) {
  return 0.21f * col.x + 0.72f * col.y + 0.07f * col.z;
}

float4 pattern(int2 loc) {
  const int depth = 16;
  float a = ((float)((loc.x * 2 + loc.y) % depth) / (float)depth);
  float b = ((float)((loc.y * 2 + loc.x) % depth) / (float)depth);
  float c = ((float)((loc.x + loc.y) % depth) / (float)depth);
  return (float4)(a, b, c, 1.0f);
}

float4 RGB2CMY(float4 rgb) {
  return (float4)(1.0f - rgb.x, 1.0f - rgb.y, 1.0f - rgb.z, 1.0f);
}

kernel void video_image(read_only image2d_t in, write_only image2d_t out) {
  const sampler_t format = 0 | 0x10 | 4;
  const int2 d = (int2)(get_global_id(0), get_global_id(1));
  float4 col = read_imagef(in, format, d);

  float4 pat = pattern(d);
  float4 res = RGB2CMY(col) * pat;
  float4 oc = (float4)((res.x > 0.5f) ? 1.0f : 0.0f, (res.y > 0.5f) ? 1.0f : 0.0f, (res.z > 0.5f) ? 1.0f : 0.0f, 1.0f);
  write_imagef(out, d, RGB2CMY(oc));
}