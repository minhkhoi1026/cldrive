//{"clarity":6,"g":2,"highlights":5,"ht":8,"input":0,"output":1,"shadows":4,"sigma":3,"w":11,"wd":7,"xtrans":10,"xtrans[row % 6]":9}
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
          c += pixel.x * w[hook(11, 2 * jj + 2)] * w[hook(11, 2 * ii + 2)];
        }
      break;
    case 1:
      for (int ii = 0; ii <= 1; ii++)
        for (int jj = -1; jj <= 1; jj++) {
          float4 pixel = read_imagef(coarse, sampleri, (int2)(cx + ii, cy + jj));
          c += pixel.x * w[hook(11, 2 * jj + 2)] * w[hook(11, 2 * ii + 1)];
        }
      break;
    case 2:
      for (int ii = -1; ii <= 1; ii++)
        for (int jj = 0; jj <= 1; jj++) {
          float4 pixel = read_imagef(coarse, sampleri, (int2)(cx + ii, cy + jj));
          c += pixel.x * w[hook(11, 2 * jj + 1)] * w[hook(11, 2 * ii + 2)];
        }
      break;
    default:
      for (int ii = 0; ii <= 1; ii++)
        for (int jj = 0; jj <= 1; jj++) {
          float4 pixel = read_imagef(coarse, sampleri, (int2)(cx + ii, cy + jj));
          c += pixel.x * w[hook(11, 2 * jj + 1)] * w[hook(11, 2 * ii + 1)];
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

kernel void process_curve(read_only image2d_t input, write_only image2d_t output, const float g, const float sigma, const float shadows, const float highlights, const float clarity, const int wd, const int ht) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  if (x >= wd || y >= ht)
    return;

  float4 pixel = read_imagef(input, sampleri, (int2)(x, y));
  pixel.x = curve(pixel.x, g, sigma, shadows, highlights, clarity);
  write_imagef(output, (int2)(x, y), pixel);
}