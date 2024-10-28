//{"col":11,"height":3,"in":0,"out":1,"r_scale":8,"r_x":4,"r_y":5,"rin_ht":7,"rin_wd":6,"width":2,"xtrans":9,"xtrans[row % 6]":10}
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
  return xtrans[hook(9, row % 6)][hook(10, col % 6)];
}

int fcol(const int row, const int col, const unsigned int filters, global const unsigned char (*const xtrans)[6]) {
  if (filters == 9)

    return FCxtrans(row + 6, col + 6, xtrans);
  else
    return FC(row, col, filters);
}

kernel void clip_and_zoom_demosaic_third_size_xtrans(read_only image2d_t in, write_only image2d_t out, const int width, const int height, const int r_x, const int r_y, const int rin_wd, const int rin_ht, const float r_scale, global const unsigned char (*const xtrans)[6]) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;
  float col[3] = {0.0f};
  int num = 0;

  const float px_footprint = 1.0f / r_scale;
  const int samples = max(1, (int)floor(px_footprint / 3.0f));

  const int px = clamp((int)round((x - 0.5f) * px_footprint), 0, rin_wd - 3);
  const int py = clamp((int)round((y - 0.5f) * px_footprint), 0, rin_ht - 3);

  const int xmax = min(rin_wd - 3, px + 3 * samples);
  const int ymax = min(rin_ht - 3, py + 3 * samples);

  for (int yy = py; yy <= ymax; yy += 3)
    for (int xx = px; xx <= xmax; xx += 3) {
      for (int j = 0; j < 3; j++)
        for (int i = 0; i < 3; i++)
          col[hook(11, FCxtrans(yy + j + r_y, xx + i + r_x, xtrans))] += read_imagef(in, sampleri, (int2)(xx + i, yy + j)).x;
      num++;
    }

  col[hook(11, 0)] /= (num * 2);
  col[hook(11, 1)] /= (num * 5);
  col[hook(11, 2)] /= (num * 2);

  write_imagef(out, (int2)(x, y), (float4)(col[hook(11, 0)], col[hook(11, 1)], col[hook(11, 2)], 0.0f));
}