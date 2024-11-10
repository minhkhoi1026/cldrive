//{"BSIZE":5,"FSIZE":4,"Nx":2,"Ny":3,"SIGMA":6,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void run2d_float(read_only image2d_t input, global float* output, const int Nx, const int Ny, const int FSIZE, const int BSIZE, const float SIGMA) {
  const sampler_t sampler = 0 | 2 | 0x10;

  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);

  float pix0 = read_imageui(input, sampler, (int2)(i, j)).x;

  float res = 0;
  float sum = 0;

  float foo;

  float pix1;
  float p0, p1;

  for (int i1 = -BSIZE; i1 <= BSIZE; i1++) {
    for (int j1 = -BSIZE; j1 <= BSIZE; j1++) {
      float weight = 0;
      float dist = 0;

      pix1 = read_imagef(input, sampler, (int2)(i + i1, j + j1)).x;

      for (int i2 = -FSIZE; i2 <= FSIZE; i2++) {
        for (int j2 = -FSIZE; j2 <= FSIZE; j2++) {
          p0 = read_imagef(input, sampler, (int2)(i + i2, j + j2)).x;

          p1 = read_imagef(input, sampler, (int2)(i + i1 + i2, j + j1 + j2)).x;

          dist += (1.f * p1 - 1.f * p0) * (1.f * p1 - 1.f * p0);
        }
      }

      dist *= 1. / (2 * FSIZE + 1) / (2 * FSIZE + 1);

      weight = exp(-1.f / SIGMA / SIGMA * dist);
      res += 1.f * pix1 * weight;
      sum += weight;
    }
  }
  output[hook(1, i + j * Nx)] = (float)(res / sum);
}