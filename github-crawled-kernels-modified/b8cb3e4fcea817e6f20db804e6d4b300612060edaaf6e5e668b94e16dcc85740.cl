//{"Nx":2,"Ny":3,"a":0,"b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void run(global const short* a, global short* b, const int Nx, const int Ny) {
  unsigned i = get_global_id(0);
  unsigned j = get_global_id(1);
  unsigned index = i + j * Nx;

  const int BLOCKSIZE = 3;
  const float sigma = 30;

  float res = 0;
  float sum = 0.;

  int4 nBlock = BLOCKSIZE * (int4)(-1, 1, -1, 1);

  if (i < BLOCKSIZE)
    nBlock.x = -i;
  if (i + BLOCKSIZE >= Nx)
    nBlock.y = Nx - i - 1;

  if (j < BLOCKSIZE)
    nBlock.z = -j;
  if (j + BLOCKSIZE >= Ny)
    nBlock.w = Ny - j - 1;

  for (int k = nBlock.x; k <= nBlock.y; k++) {
    for (int m = nBlock.z; m <= nBlock.w; m++) {
      int ind = (i + k) + (j + m) * Nx;
      float weight = exp(-1.f / sigma / sigma * (a[hook(0, index)] - a[hook(0, ind)]) * (a[hook(0, index)] - a[hook(0, ind)]));

      res += a[hook(0, ind)] * weight;
      sum += weight;
    }
  }

  b[hook(1, index)] = (short)(res / sum);
}