//{"ht":5,"input":0,"max_supp":3,"output":2,"processed":1,"w":8,"wd":4,"xtrans":7,"xtrans[row % 6]":6}
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
  return xtrans[hook(7, row % 6)][hook(6, col % 6)];
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
          c += pixel.x * w[hook(8, 2 * jj + 2)] * w[hook(8, 2 * ii + 2)];
        }
      break;
    case 1:
      for (int ii = 0; ii <= 1; ii++)
        for (int jj = -1; jj <= 1; jj++) {
          float4 pixel = read_imagef(coarse, sampleri, (int2)(cx + ii, cy + jj));
          c += pixel.x * w[hook(8, 2 * jj + 2)] * w[hook(8, 2 * ii + 1)];
        }
      break;
    case 2:
      for (int ii = -1; ii <= 1; ii++)
        for (int jj = 0; jj <= 1; jj++) {
          float4 pixel = read_imagef(coarse, sampleri, (int2)(cx + ii, cy + jj));
          c += pixel.x * w[hook(8, 2 * jj + 1)] * w[hook(8, 2 * ii + 2)];
        }
      break;
    default:
      for (int ii = 0; ii <= 1; ii++)
        for (int jj = 0; jj <= 1; jj++) {
          float4 pixel = read_imagef(coarse, sampleri, (int2)(cx + ii, cy + jj));
          c += pixel.x * w[hook(8, 2 * jj + 1)] * w[hook(8, 2 * ii + 1)];
        }
      break;
  }
  return 4.0f * c;
}

float laplacian(read_only image2d_t coarse, read_only image2d_t fine, const int i, const int j, const int ci, const int cj, const int wd, const int ht) {
  const float c = expand_gaussian(coarse, ci, cj, wd, ht);
  return read_imagef(fine, sampleri, (int2)(i, j)).x - c;
}

float curve(const float x, const float g, const float sigma, const float shadows, const float highlights, const float clarity) {
  const float c = x - g;
  float val;
  const float ssigma = c > 0.0f ? sigma : -sigma;
  const float shadhi = c > 0.0f ? shadows : highlights;
  if (fabs(c) > 2 * sigma)
    val = g + ssigma + shadhi * (c - ssigma);
  else {
    const float t = clamp(c / (2.0f * ssigma), 0.0f, 1.0f);
    const float t2 = t * t;
    const float mt = 1.0f - t;
    val = g + ssigma * 2.0f * mt * t + t2 * (ssigma + ssigma * shadhi);
  }

  val += clarity * c * native_exp(-c * c / (2.0f * sigma * sigma / 3.0f));
  return val;
}

kernel void write_back(read_only image2d_t input, read_only image2d_t processed, write_only image2d_t output, const int max_supp, const int wd, const int ht) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  if (x >= wd || y >= ht)
    return;

  float4 pixel = read_imagef(input, sampleri, (int2)(x, y));
  pixel.x = 100.0f * read_imagef(processed, sampleri, (int2)(x + max_supp, y + max_supp)).x;
  write_imagef(output, (int2)(x, y), pixel);
}