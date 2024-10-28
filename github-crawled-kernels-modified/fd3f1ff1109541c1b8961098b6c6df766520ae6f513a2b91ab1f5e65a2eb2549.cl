//{"density":5,"float3":4,"height":3,"in":0,"length_base":6,"length_inc_x":7,"length_inc_y":8,"out":1,"width":2,"xtrans":10,"xtrans[row % 6]":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampleri = 0 | 2 | 0x10;
constant sampler_t samplerf = 0 | 2 | 0x20;
constant sampler_t samplerc = 0 | 4 | 0x10;
int FC(const int row, const int col, const unsigned int filters) {
  return filters >> ((((row) << 1 & 14) + ((col)&1)) << 1) & 3;
}

int FCxtrans(const int row, const int col, global const unsigned char (*const xtrans)[6]) {
  return xtrans[hook(10, row % 6)][hook(9, col % 6)];
}

kernel void graduatedndp(read_only image2d_t in, write_only image2d_t out, const int width, const int height, const float4 float3, const float density, const float length_base, const float length_inc_x, const float length_inc_y) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  float4 pixel = read_imagef(in, sampleri, (int2)(x, y));

  const float len = length_base + y * length_inc_y + x * length_inc_x;

  const float t = 0.693147181f * (density * clamp(0.5f + len, 0.0f, 1.0f) / 8.0f);
  const float d1 = t * t * 0.5f;
  const float d2 = d1 * t * 0.333333333f;
  const float d3 = d2 * t * 0.25f;
  float dens = 1.0f + t + d1 + d2 + d3;
  dens *= dens;
  dens *= dens;
  dens *= dens;

  pixel.xyz = fmax((float4)0.0f, pixel / (float3 + ((float4)1.0f - float3) * (float4)dens)).xyz;

  write_imagef(out, (int2)(x, y), pixel);
}