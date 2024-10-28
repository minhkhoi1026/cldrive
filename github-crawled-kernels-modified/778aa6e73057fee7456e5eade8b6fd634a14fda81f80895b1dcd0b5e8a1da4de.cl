//{"Nx":2,"Ny":3,"SIGMA":4,"input":0,"localPix":6,"localPix[iLoc + 5 + 3 + i1 + i2]":9,"localPix[iLoc + 5 + 3 + i1]":7,"localPix[iLoc + 5 + 3 + i2]":8,"localPix[iLoc + k * 16]":5,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void run2d_SHARED(read_only image2d_t input, global short* output, const int Nx, const int Ny, const float SIGMA) {
  const sampler_t sampler = 0 | 2 | 0x10;

  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);
  unsigned int iLoc = get_local_id(0);
  unsigned int jLoc = get_local_id(1);

  unsigned int i0 = i - iLoc;
  unsigned int j0 = j - jLoc;

  local unsigned int localPix[(2 * (5 + 3) + 16)][(2 * (5 + 3) + 16)];

  for (int k = 0; k < (2 * (5 + 3) + 16) / 16 + 1; ++k) {
    if (iLoc + k * 16 < (2 * (5 + 3) + 16)) {
      for (int m = 0; m < (2 * (5 + 3) + 16) / 16 + 1; ++m) {
        if (jLoc + m * 16 < (2 * (5 + 3) + 16)) {
          localPix[hook(6, iLoc + k * 16)][hook(5, jLoc + m * 16)] = read_imageui(input, sampler, (int2)(i - 5 - 3 + k * 16, j - 5 - 3 + m * 16)).x;
        };
      }
    }
  }

  barrier(0x01);

  float res = 0;
  float sum = 0;

  unsigned int pix1;
  unsigned int p0, p1;

  for (int i1 = -5; i1 <= 5; i1++) {
    for (int j1 = -5; j1 <= 5; j1++) {
      float weight = 0;
      float dist = 0;

      pix1 = localPix[hook(6, iLoc + 5 + 3 + i1)][hook(7, jLoc + 5 + 3 + j1)];

      for (int i2 = -3; i2 <= 3; i2++) {
        for (int j2 = -3; j2 <= 3; j2++) {
          p0 = localPix[hook(6, iLoc + 5 + 3 + i2)][hook(8, jLoc + 5 + 3 + j2)];
          p1 = localPix[hook(6, iLoc + 5 + 3 + i1 + i2)][hook(9, jLoc + 5 + 3 + j1 + j2)];

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