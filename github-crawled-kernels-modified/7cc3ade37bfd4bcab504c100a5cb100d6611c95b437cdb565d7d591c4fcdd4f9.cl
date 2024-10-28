//{"filters":9,"height":3,"in":0,"out":1,"r_scale":8,"r_x":4,"r_y":5,"rin_ht":7,"rin_wd":6,"width":2,"xtrans":11,"xtrans[row % 6]":10}
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
  return xtrans[hook(11, row % 6)][hook(10, col % 6)];
}

kernel void clip_and_zoom_demosaic_passthrough_monochrome(read_only image2d_t in, write_only image2d_t out, const int width, const int height, const int r_x, const int r_y, const int rin_wd, const int rin_ht, const float r_scale, const unsigned int filters) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  float4 float3 = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  float weight = 0.0f;

  const float px_footprint = 1.0f / r_scale;

  const int samples = round(px_footprint);

  const float2 f = (float2)((x + r_x) * px_footprint, (y + r_y) * px_footprint);
  int2 p = (int2)((int)f.x, (int)f.y);
  const float2 d = (float2)(f.x - p.x, f.y - p.y);

  for (int j = 0; j <= samples + 1; j++)
    for (int i = 0; i <= samples + 1; i++) {
      const int xx = p.x + i;
      const int yy = p.y + j;

      float xfilter = (i == 0) ? 1.0f - d.x : ((i == samples + 1) ? d.x : 1.0f);
      float yfilter = (j == 0) ? 1.0f - d.y : ((j == samples + 1) ? d.y : 1.0f);

      float px = read_imagef(in, sampleri, (int2)(xx, yy)).x;
      float3 += yfilter * xfilter * (float4)(px, px, px, 0.0f);
      weight += yfilter * xfilter;
    }
  float3 = weight > 0.0f ? float3 / weight : (float4)0.0f;
  write_imagef(out, (int2)(x, y), float3);
}