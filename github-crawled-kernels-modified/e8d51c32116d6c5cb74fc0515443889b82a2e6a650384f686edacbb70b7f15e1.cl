//{"filters":4,"gr_ratio":7,"height":3,"in":0,"out":1,"r_x":5,"r_y":6,"width":2,"xtrans":9,"xtrans[row % 6]":8}
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
  return xtrans[hook(9, row % 6)][hook(8, col % 6)];
}
int2 backtransformi(float2 p, const int r_x, const int r_y, const int r_wd, const int r_ht, const float r_scale) {
  return (int2)((p.x + r_x) / r_scale, (p.y + r_y) / r_scale);
}

float2 backtransformf(float2 p, const int r_x, const int r_y, const int r_wd, const int r_ht, const float r_scale) {
  return (float2)((p.x + r_x) / r_scale, (p.y + r_y) / r_scale);
}

kernel void green_equilibration_favg_apply(read_only image2d_t in, write_only image2d_t out, const int width, const int height, const unsigned int filters, const int r_x, const int r_y, const float gr_ratio) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  float pixel = read_imagef(in, sampleri, (int2)(x, y)).x;

  const int c = FC(y + r_y, x + r_x, filters);

  const int isgreen1 = (c == 1 && !((y + r_y) & 1));

  pixel *= (isgreen1 ? gr_ratio : 1.0f);

  write_imagef(out, (int2)(x, y), pixel);
}