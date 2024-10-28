//{"height":3,"in":0,"out":1,"width":2,"xtrans":5,"xtrans[row % 6]":4}
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
  return xtrans[hook(5, row % 6)][hook(4, col % 6)];
}

int fcol(const int row, const int col, const unsigned int filters, global const unsigned char (*const xtrans)[6]) {
  if (filters == 9)

    return FCxtrans(row + 6, col + 6, xtrans);
  else
    return FC(row, col, filters);
}

kernel void vng_green_equilibrate(read_only image2d_t in, write_only image2d_t out, const int width, const int height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  float4 pixel = read_imagef(in, sampleri, (int2)(x, y));

  pixel.y = (pixel.y + pixel.w) / 2.0f;
  pixel.w = 0.0f;

  write_imagef(out, (int2)(x, y), pixel);
}