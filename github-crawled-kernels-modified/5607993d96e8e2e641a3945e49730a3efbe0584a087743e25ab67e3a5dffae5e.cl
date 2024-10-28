//{"Nx":2,"Ny":3,"aLoc":4,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void run(read_only image2d_t input, global short* output, const int Nx, const int Ny) {
  const sampler_t sampler = 0 | 2 | 0x10;

  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);

  unsigned int iGroup = get_local_id(0);
  unsigned int jGroup = get_local_id(1);

  unsigned int index = i + j * Nx;
  unsigned int indexGroup = iGroup + jGroup * 16;

  int2 pos0 = (int2)(i, j);

  const int ASTRIDE = ceil(1.f * (16 + 2 * 5) * (16 + 2 * 5) / 16 / 16);

  local float aLoc[(16 + 2 * 5) * (16 + 2 * 5)];

  for (int k = 0; k < ASTRIDE; ++k) {
    unsigned int indexLoc = indexGroup * ASTRIDE + k;
    if (indexLoc < ((16 + 2 * 5) * (16 + 2 * 5))) {
      aLoc[hook(4, indexLoc)] = 4.f;
    }
  }

  barrier(0x01);

  float res = 0;
  float sum = 0;

  for (int k = -5; k <= 5; k++) {
    for (int m = -5; m <= 5; m++) {
      float pix1 = aLoc[hook(4, index % ((16 + 2 * 5) * (16 + 2 * 5)))];
      float weight = exp(-1.f / 30.f / 30.f * (k * k + m * m));
      res += pix1 * weight;
      sum += weight;
    }
  }

  output[hook(1, i + Nx * j)] = (short)(res / sum);
}