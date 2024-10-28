//{"ht":3,"ht2":6,"input":0,"max_supp":4,"padded":1,"wd":2,"wd2":5,"xtrans":8,"xtrans[row % 6]":7}
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
  return xtrans[hook(8, row % 6)][hook(7, col % 6)];
}

kernel void pad_input(read_only image2d_t input, write_only image2d_t padded, const int wd, const int ht, const int max_supp, const int wd2, const int ht2) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  int cx = x - max_supp, cy = y - max_supp;

  if (x >= wd2 || y >= ht2)
    return;

  if (cx >= wd)
    cx = wd - 1;
  if (cy >= ht)
    cy = ht - 1;
  if (cx < 0)
    cx = 0;
  if (cy < 0)
    cy = 0;

  float4 pixel = read_imagef(input, sampleri, (int2)(cx, cy));
  write_imagef(padded, (int2)(x, y), pixel.x * 0.01f);
}