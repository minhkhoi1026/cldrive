//{"buf_g0_l0":3,"buf_g0_l1":4,"buf_g1_l0":5,"buf_g1_l1":6,"buf_g2_l0":7,"buf_g2_l1":8,"buf_g3_l0":9,"buf_g3_l1":10,"buf_g4_l0":11,"buf_g4_l1":12,"buf_g5_l0":13,"buf_g5_l1":14,"input":0,"output0":2,"output1":1,"ph":16,"pw":15,"w":19,"xtrans":18,"xtrans[row % 6]":17}
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
  return xtrans[hook(18, row % 6)][hook(17, col % 6)];
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
          c += pixel.x * w[hook(19, 2 * jj + 2)] * w[hook(19, 2 * ii + 2)];
        }
      break;
    case 1:
      for (int ii = 0; ii <= 1; ii++)
        for (int jj = -1; jj <= 1; jj++) {
          float4 pixel = read_imagef(coarse, sampleri, (int2)(cx + ii, cy + jj));
          c += pixel.x * w[hook(19, 2 * jj + 2)] * w[hook(19, 2 * ii + 1)];
        }
      break;
    case 2:
      for (int ii = -1; ii <= 1; ii++)
        for (int jj = 0; jj <= 1; jj++) {
          float4 pixel = read_imagef(coarse, sampleri, (int2)(cx + ii, cy + jj));
          c += pixel.x * w[hook(19, 2 * jj + 1)] * w[hook(19, 2 * ii + 2)];
        }
      break;
    default:
      for (int ii = 0; ii <= 1; ii++)
        for (int jj = 0; jj <= 1; jj++) {
          float4 pixel = read_imagef(coarse, sampleri, (int2)(cx + ii, cy + jj));
          c += pixel.x * w[hook(19, 2 * jj + 1)] * w[hook(19, 2 * ii + 1)];
        }
      break;
  }
  return 4.0f * c;
}

float laplacian(read_only image2d_t coarse, read_only image2d_t fine, const int i, const int j, const int ci, const int cj, const int wd, const int ht) {
  const float c = expand_gaussian(coarse, ci, cj, wd, ht);
  return read_imagef(fine, sampleri, (int2)(i, j)).x - c;
}

kernel void laplacian_assemble(read_only image2d_t input, read_only image2d_t output1, write_only image2d_t output0, read_only image2d_t buf_g0_l0, read_only image2d_t buf_g0_l1, read_only image2d_t buf_g1_l0, read_only image2d_t buf_g1_l1, read_only image2d_t buf_g2_l0, read_only image2d_t buf_g2_l1, read_only image2d_t buf_g3_l0, read_only image2d_t buf_g3_l1, read_only image2d_t buf_g4_l0, read_only image2d_t buf_g4_l1, read_only image2d_t buf_g5_l0, read_only image2d_t buf_g5_l1,

                               const int pw, const int ph) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  int i = x, j = y;

  if (x >= pw || y >= ph)
    return;

  if (pw & 1) {
    if (x > pw - 2)
      i = pw - 2;
  } else {
    if (x > pw - 3)
      i = pw - 3;
  }
  if (ph & 1) {
    if (y > ph - 2)
      j = ph - 2;
  } else {
    if (y > ph - 3)
      j = ph - 3;
  }
  if (x <= 0)
    i = 1;
  if (y <= 0)
    j = 1;

  float4 pixel;
  pixel.x = expand_gaussian(output1, i, j, pw, ph);

  const int num_gamma = 6;
  const float v = read_imagef(input, sampleri, (int2)(x, y)).x;
  int hi = 1;

  for (; hi < num_gamma - 1 && ((float)hi + .5f) / (float)num_gamma <= v; hi++)
    ;
  int lo = hi - 1;

  const float a = fmin(fmax(v * num_gamma - ((float)lo + .5f), 0.0f), 1.0f);
  float l0, l1;
  switch (lo) {
    case 0:
      l0 = laplacian(buf_g0_l1, buf_g0_l0, x, y, i, j, pw, ph);
      l1 = laplacian(buf_g1_l1, buf_g1_l0, x, y, i, j, pw, ph);
      break;
    case 1:
      l0 = laplacian(buf_g1_l1, buf_g1_l0, x, y, i, j, pw, ph);
      l1 = laplacian(buf_g2_l1, buf_g2_l0, x, y, i, j, pw, ph);
      break;
    case 2:
      l0 = laplacian(buf_g2_l1, buf_g2_l0, x, y, i, j, pw, ph);
      l1 = laplacian(buf_g3_l1, buf_g3_l0, x, y, i, j, pw, ph);
      break;
    case 3:
      l0 = laplacian(buf_g3_l1, buf_g3_l0, x, y, i, j, pw, ph);
      l1 = laplacian(buf_g4_l1, buf_g4_l0, x, y, i, j, pw, ph);
      break;
    default:
      l0 = laplacian(buf_g4_l1, buf_g4_l0, x, y, i, j, pw, ph);
      l1 = laplacian(buf_g5_l1, buf_g5_l0, x, y, i, j, pw, ph);
      break;
  }
  pixel.x += l0 * (1.0f - a) + l1 * a;
  write_imagef(output0, (int2)(x, y), pixel);
}