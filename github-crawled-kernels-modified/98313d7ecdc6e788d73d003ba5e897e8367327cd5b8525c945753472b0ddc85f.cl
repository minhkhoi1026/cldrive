//{"coarse":0,"fine":1,"ht":3,"w":6,"wd":2,"xtrans":5,"xtrans[row % 6]":4}
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

float expand_gaussian(read_only image2d_t coarse, const int i, const int j, const int wd, const int ht) {
  float c = 0.0f;
  const float w[5] = {1.0f / 16.0f, 4.0f / 16.0f, 6.0f / 16.0f, 4.0f / 16.0f, 1.0f / 16.0f};
  const int cx = i / 2;
  const int cy = j / 2;
  switch ((i & 1) + 2 * (j & 1)) {
    case 0:
      for (int ii = -1; ii <= 1; ii++)
        for (int jj = -1; jj <= 1; jj++) {
          float4 pixel = read_imagef(coarse, sampleri, (int2)(cx + ii, cy + jj));
          c += pixel.x * w[hook(6, 2 * jj + 2)] * w[hook(6, 2 * ii + 2)];
        }
      break;
    case 1:
      for (int ii = 0; ii <= 1; ii++)
        for (int jj = -1; jj <= 1; jj++) {
          float4 pixel = read_imagef(coarse, sampleri, (int2)(cx + ii, cy + jj));
          c += pixel.x * w[hook(6, 2 * jj + 2)] * w[hook(6, 2 * ii + 1)];
        }
      break;
    case 2:
      for (int ii = -1; ii <= 1; ii++)
        for (int jj = 0; jj <= 1; jj++) {
          float4 pixel = read_imagef(coarse, sampleri, (int2)(cx + ii, cy + jj));
          c += pixel.x * w[hook(6, 2 * jj + 1)] * w[hook(6, 2 * ii + 2)];
        }
      break;
    default:
      for (int ii = 0; ii <= 1; ii++)
        for (int jj = 0; jj <= 1; jj++) {
          float4 pixel = read_imagef(coarse, sampleri, (int2)(cx + ii, cy + jj));
          c += pixel.x * w[hook(6, 2 * jj + 1)] * w[hook(6, 2 * ii + 1)];
        }
      break;
  }
  return 4.0f * c;
}

kernel void gauss_expand(read_only image2d_t coarse, write_only image2d_t fine, const int wd, const int ht) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  int cx = x, cy = y;

  float4 pixel;
  if (x >= wd || y >= ht)
    return;

  if (wd & 1) {
    if (x > wd - 2)
      cx = wd - 2;
  } else {
    if (x > wd - 3)
      cx = wd - 3;
  }
  if (ht & 1) {
    if (y > ht - 2)
      cy = ht - 2;
  } else {
    if (y > ht - 3)
      cy = ht - 3;
  }
  if (cx <= 0)
    cx = 1;
  if (cy <= 0)
    cy = 1;

  pixel.x = expand_gaussian(coarse, cx, cy, wd, ht);
  write_imagef(fine, (int2)(x, y), pixel);
}