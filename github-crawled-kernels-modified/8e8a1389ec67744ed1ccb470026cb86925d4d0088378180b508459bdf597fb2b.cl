//{"height":4,"in_a":0,"in_b":1,"out":2,"width":3,"xtrans":6,"xtrans[row % 6]":5}
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
  return xtrans[hook(6, row % 6)][hook(5, col % 6)];
}

kernel void bloom_mix(read_only image2d_t in_a, read_only image2d_t in_b, write_only image2d_t out, const int width, const int height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  float4 pixel = read_imagef(in_a, sampleri, (int2)(x, y));
  float processed = read_imagef(in_b, sampleri, (int2)(x, y)).x;

  pixel.x = 100.0f - (((100.0f - pixel.x) * (100.0f - processed)) / 100.0f);

  write_imagef(out, (int2)(x, y), pixel);
}