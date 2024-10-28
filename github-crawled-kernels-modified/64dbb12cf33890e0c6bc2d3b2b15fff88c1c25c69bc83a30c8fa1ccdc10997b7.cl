//{"Nx":2,"Ny":3,"fSize":4,"input":0,"output":1,"sigmaP":6,"sigmaX":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bilat2_float(read_only image2d_t input, global float* output, const int Nx, const int Ny, const int fSize, const float sigmaX, const float sigmaP) {
  const sampler_t sampler = 0 | 2 | 0x10;

  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);

  float res = 0;
  float sum = 0;
  float pix0 = read_imagef(input, sampler, (int2)(i, j)).x;

  float SX = 1.f / sigmaX / sigmaX;
  float SP = 1.f / sigmaP / sigmaP;

  for (int k = -fSize; k <= fSize; k++) {
    for (int m = -fSize; m <= fSize; m++) {
      float pix1 = read_imagef(input, sampler, (int2)(i + k, j + m)).x;
      float weight = exp(-SX * (k * k + m * m)) * exp(-SP * ((1.f * pix0 - pix1) * (1.f * pix0 - pix1)));
      res += pix1 * weight;
      sum += weight;
    }
  }

  output[hook(1, i + Nx * j)] = res / sum;
}