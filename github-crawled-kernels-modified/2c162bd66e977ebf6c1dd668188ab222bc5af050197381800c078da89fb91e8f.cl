//{"Nx":2,"Ny":3,"input":0,"output":1,"sigma":4,"thresh":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nlm3_thresh(read_only image3d_t input, global short* output, const int Nx, const int Ny, const float sigma, const float thresh) {
  const sampler_t sampler = 0 | 2 | 0x10;

  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);
  unsigned int k = get_global_id(2);

  float res = 0.f;
  float meanSum = 0.f, sum = 0.f;

  unsigned int pix;

  float patch_norm = 1.f / (2 * 2 + 1) / (2 * 2 + 1) / (2 * 2 + 1);

  for (int i2 = -2; i2 <= 2; i2++) {
    for (int j2 = -2; j2 <= 2; j2++) {
      for (int k2 = -2; k2 <= 2; k2++) {
        pix = read_imageui(input, sampler, (int4)(i + i2, j + j2, k + k2, 0)).x;
        meanSum += pix;
      }
    }
  }
  meanSum *= patch_norm;

  if (meanSum > thresh) {
    for (int i1 = -3; i1 <= 3; i1++) {
      for (int j1 = -3; j1 <= 3; j1++) {
        for (int k1 = -3; k1 <= 3; k1++) {
          float weight = 0;
          float dist = 0;

          pix = read_imageui(input, sampler, (int4)(i + i1, j + j1, k + k1, 0)).x;

          for (int i2 = -2; i2 <= 2; i2++) {
            for (int j2 = -2; j2 <= 2; j2++) {
              for (int k2 = -2; k2 <= 2; k2++) {
                unsigned int p0 = read_imageui(input, sampler, (int4)(i + i2, j + j2, k + k2, 0)).x;
                ;

                unsigned int p1 = read_imageui(input, sampler, (int4)(i + i1 + i2, j + j1 + j2, k + k1 + k2, 0)).x;

                dist += (1.f * p1 - 1.f * p0) * (1.f * p1 - 1.f * p0);
              }
            }
          }

          weight = exp(-1.f * dist * patch_norm / sigma / sigma);
          res += pix * weight;
          sum += weight;
        }
      }
    }

    output[hook(1, i + j * Nx + k * Nx * Ny)] = (unsigned int)(res / sum);

  } else {
    pix = read_imageui(input, sampler, (int4)(i, j, k, 0)).x;

    for (int i2 = -2; i2 <= 2; i2++) {
      for (int j2 = -2; j2 <= 2; j2++) {
        for (int k2 = -2; k2 <= 2; k2++) {
          unsigned int pix2 = read_imageui(input, sampler, (int4)(i + i2, j + j2, k + k2, 0)).x;

          unsigned int dist = (1.f * pix2 - pix) * (1.f * pix2 - pix);
          float weight = exp(-.1f * (i2 * i2 + j2 * j2 + k2 * k2) - dist * patch_norm / sigma);

          res += pix2 * weight;
          sum += weight;
        }
      }
    }

    output[hook(1, i + j * Nx + k * Nx * Ny)] = (short)(res / sum);
  }
}