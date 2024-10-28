//{"Nx":3,"Ny":4,"Nz":5,"input1":0,"input2":1,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void run(read_only image3d_t input1, read_only image3d_t input2, global short* output, const int Nx, const int Ny, const int Nz) {
  const int FSIZE = 1;
  const int NSIZE = 2;
  const float SIGMA = 10.f;

  const sampler_t sampler = 0 | 2 | 0x10;

  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);
  unsigned int k = get_global_id(2);

  int pix0 = (int)(read_imageui(input1, sampler, (int4)(i, j, k, 0)).x);

  float res = 0;
  float sum = 0;

  for (int i2 = -NSIZE; i2 <= NSIZE; i2++) {
    for (int j2 = -NSIZE; j2 <= NSIZE; j2++) {
      for (int k2 = -NSIZE; k2 <= NSIZE; k2++) {
        float dist = 0.f;

        for (int i3 = -FSIZE; i3 <= FSIZE; i3++) {
          for (int j3 = -FSIZE; j3 <= FSIZE; j3++) {
            for (int k3 = -FSIZE; k3 <= FSIZE; k3++) {
              float p1 = (float)(read_imageui(input1, sampler, (int4)(i + i3, j + j3, k + k3, 0)).x);
              float p2 = (float)(read_imageui(input2, sampler, (int4)(i + i2 + i3, j + j2 + j3, k + k2 + k3, 0)).x);

              dist += .1f * (p1 - p2) * (p1 - p2);
            }
          }
        }

        int pix1 = read_imageui(input2, sampler, (int4)(i + i2, j + j2, k + k2, 0)).x;

        float weight = exp(-1.f / SIGMA / SIGMA * dist);

        res += pix1 * weight;
        sum += weight;
      }
    }
  }

  output[hook(2, i + j * Nx + k * Nx * Ny)] = (short)(res / sum);
}