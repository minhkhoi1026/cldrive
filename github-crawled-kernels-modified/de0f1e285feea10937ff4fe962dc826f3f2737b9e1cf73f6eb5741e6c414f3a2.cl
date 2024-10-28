//{"Nx":2,"Ny":3,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void run(read_only image2d_t input, global short* output, const int Nx, const int Ny) {
  const sampler_t sampler = 0 | 2 | 0x10;

  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);

  float res = 0;
  float sum = 0;

  for (int k = -5; k <= 5; k++) {
    for (int m = -5; m <= 5; m++) {
      uint4 pix1 = read_imageui(input, sampler, (int2)(i + k, j + m));
      float weight = exp(-1.f / 10.f / 10.f * (k * k + m * m));
      res += pix1.x * weight;
      sum += weight;
    }
  }

  output[hook(1, i + Nx * j)] = (short)(res / sum);
}