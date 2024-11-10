//{"BSIZE":5,"FSIZE":4,"Nx":2,"Ny":3,"SIGMA":6,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void run2dBuf(global short* input, global short* output, const int Nx, const int Ny, const int FSIZE, const int BSIZE, const float SIGMA) {
  const sampler_t sampler = 0 | 2 | 0x10;

  unsigned int i0 = get_global_id(0);

  unsigned int i = i0 % Nx;
  unsigned int j = i0 / Nx;

  unsigned int pix0 = input[hook(0, i + j * Nx)];

  float res = 0;
  float sum = 0;

  float foo;

  unsigned int pix1;
  unsigned int p0, p1;

  for (int i1 = -BSIZE; i1 <= BSIZE; i1++) {
    for (int j1 = -BSIZE; j1 <= BSIZE; j1++) {
      float weight = 0;
      float dist = 0;

      pix1 = input[hook(0, (i + i1) + (j + j1) * Nx)];

      for (int i2 = -FSIZE; i2 <= FSIZE; i2++) {
        for (int j2 = -FSIZE; j2 <= FSIZE; j2++) {
          p0 = input[hook(0, (i + i2) + (j + j2) * Nx)];
          p1 = input[hook(0, (i + i1 + i2) + (j + j1 + j2) * Nx)];

          dist += (1.f * p1 - 1.f * p0) * (1.f * p1 - 1.f * p0) / FSIZE / FSIZE;
        }
      }

      weight = exp(-1.f / SIGMA / SIGMA * dist);
      res += 1.f * pix1 * weight;
      sum += weight;
    }
  }

  output[hook(1, i0)] = (short)(pix0);
}