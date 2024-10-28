//{"Nx":2,"Ny":3,"SIGMA":4,"input":0,"localPix":6,"localPix[(5 + 3) + i0]":5,"localPix[(5 + 3) + i1]":7,"localPix[(5 + 3) + i2 + i1]":9,"localPix[(5 + 3) + i2]":8,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void run2d_FIXED(read_only image2d_t input, global short* output, const int Nx, const int Ny, const float SIGMA) {
  const sampler_t sampler = 0 | 2 | 0x10;

  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);

  unsigned int pix0 = read_imageui(input, sampler, (int2)(i, j)).x;

  float res = 0;
  float sum = 0;

  float foo;

  unsigned int pix1;
  unsigned int p0, p1;

  unsigned int localPix[2 * (5 + 3) + 1][2 * (5 + 3) + 1];

  for (int j0 = -(5 + 3); j0 <= (5 + 3); ++j0) {
    for (int i0 = -(5 + 3); i0 <= (5 + 3); ++i0) {
      localPix[hook(6, (5 + 3) + i0)][hook(5, (5 + 3) + j0)] = read_imageui(input, sampler, (int2)(i + i0, j + j0)).x;
    }
  }

  for (int i1 = -5; i1 <= 5; i1++) {
    for (int j1 = -5; j1 <= 5; j1++) {
      float weight = 0;
      float dist = 0;

      pix1 = localPix[hook(6, (5 + 3) + i1)][hook(7, (5 + 3) + j1)];

      for (int i2 = -3; i2 <= 3; i2++) {
        for (int j2 = -3; j2 <= 3; j2++) {
          p0 = localPix[hook(6, (5 + 3) + i2)][hook(8, (5 + 3) + j2)];

          p1 = localPix[hook(6, (5 + 3) + i2 + i1)][hook(9, (5 + 3) + j2 + j1)];

          dist += (1.f * p1 - 1.f * p0) * (1.f * p1 - 1.f * p0) / 3 / 3;
        }
      }

      weight = exp(-1.f / SIGMA / SIGMA * dist);
      res += 1.f * pix1 * weight;
      sum += weight;
    }
  }
  output[hook(1, i + j * Nx)] = (short)(res / sum);
}