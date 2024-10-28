//{"height":3,"in":0,"out":1,"r_ht":7,"r_scale":8,"r_wd":6,"r_x":4,"r_y":5,"width":2,"xtrans":10,"xtrans[row % 6]":9}
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
int2 backtransformi(float2 p, const int r_x, const int r_y, const int r_wd, const int r_ht, const float r_scale) {
  return (int2)((p.x + r_x) / r_scale, (p.y + r_y) / r_scale);
}

float2 backtransformf(float2 p, const int r_x, const int r_y, const int r_wd, const int r_ht, const float r_scale) {
  return (float2)((p.x + r_x) / r_scale, (p.y + r_y) / r_scale);
}

constant int glim[5] = {0, 1, 2, 1, 0};

kernel void clip_and_zoom(read_only image2d_t in, write_only image2d_t out, const int width, const int height, const int r_x, const int r_y, const int r_wd, const int r_ht, const float r_scale) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  float4 float3 = (float4)(0.0f, 0.0f, 0.0f, 0.0f);

  const float px_footprint = 0.5f / r_scale;
  const int samples = ((int)px_footprint);
  float2 p = backtransformf((float2)(x + 0.5f, y + 0.5f), r_x, r_y, r_wd, r_ht, r_scale);
  for (int j = -samples; j <= samples; j++)
    for (int i = -samples; i <= samples; i++) {
      float4 px = read_imagef(in, samplerf, (float2)(p.x + i, p.y + j));
      float3 += px;
    }
  float3 /= (float4)((2 * samples + 1) * (2 * samples + 1));
  write_imagef(out, (int2)(x, y), float3);
}