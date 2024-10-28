//{"FSIZE":5,"Nx":2,"Ny":3,"Nz":4,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void run(read_only image3d_t input, global short* output, const int Nx, const int Ny, const int Nz, const int FSIZE) {
  const sampler_t sampler = 0 | 2 | 0x10;

  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);
  unsigned int k = get_global_id(2);

  int val0 = read_imageui(input, sampler, (int4)(i, j, k, 0)).x;

  float res = 0;
  float sum = 0;

  for (int i2 = -FSIZE; i2 <= FSIZE; i2++) {
    for (int j2 = -FSIZE; j2 <= FSIZE; j2++) {
      for (int k2 = -FSIZE; k2 <= FSIZE; k2++) {
        int val1 = read_imageui(input, sampler, (int4)(i + i2, j + j2, k + k2, 0)).x;

        int dist = (val0 - val1) * (val0 - val1);

        float weight = exp(-1.f / 15.f / 15.f * dist);
        res += val1 * weight;
        sum += weight;
      }
    }
  }

  if (i + j * Nx + k * Nx * Ny < Nx * Ny * Nz)
    output[hook(1, i + j * Nx + k * Nx * Ny)] = (short)(res / sum);
}