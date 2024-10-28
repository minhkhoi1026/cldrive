//{"Nx":3,"Ny":4,"fSize":5,"fac":7,"input":0,"output":2,"sensor":1,"sigmaX":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void run2d(read_only image2d_t input, read_only image2d_t sensor, global short* output, const int Nx, const int Ny, const int fSize, const float sigmaX, const float fac) {
  const sampler_t sampler = 0 | 2 | 0x10;

  const sampler_t samplerSensor = 0 | 2 | 0x10;

  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);

  float res = 0;
  float sum = 0;
  unsigned int pix0 = read_imageui(input, sampler, (int2)(i, j)).x;

  float sigmaP0 = 0.0001f + read_imageui(sensor, samplerSensor, (int2)(i, j)).x;
  ;

  float sigmaP = sigmaP0;

  for (int k = -fSize; k <= fSize; k++) {
    for (int m = -fSize; m <= fSize; m++) {
      unsigned int pix1 = read_imageui(input, sampler, (int2)(i + k, j + m)).x;
      float sigmaP1 = 0.0001f + read_imageui(sensor, samplerSensor, (int2)(i + k, j + m)).x;
      ;

      sigmaP = fac * (sigmaP0 + sigmaP1);
      float weight = exp(-1.f / sigmaX / sigmaX * (k * k + m * m)) * exp(-1.f / sigmaP / sigmaP * ((1.f * pix0 - pix1) * (1.f * pix0 - pix1)));

      res += pix1 * weight;
      sum += weight;
    }
  }

  output[hook(2, i + Nx * j)] = (short)(res / sum);
}