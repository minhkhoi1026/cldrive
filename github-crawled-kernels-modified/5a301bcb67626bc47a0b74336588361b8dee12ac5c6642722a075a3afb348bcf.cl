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

  float res = 0;
  float sum = 0.;

  int4 nBlock = 5 * (int4)(-1, 1, -1, 1);

  if (i < 5)
    nBlock.x = -i;
  if (i + 5 >= Nx)
    nBlock.y = Nx - i - 1;

  if (j < 5)
    nBlock.z = -j;
  if (j + 5 >= Ny)
    nBlock.w = Ny - j - 1;

  for (int k = nBlock.x; k <= nBlock.y; k++) {
    for (int m = nBlock.z; m <= nBlock.w; m++) {
      int ind = (i + k) + (j + m) * Nx;
      float weight = exp(-.0001 * (a[hook(0, index)] - a[hook(0, ind)]) * (a[hook(0, index)] - a[hook(0, ind)]));
      res += a[hook(0, ind)] * weight;
      sum += weight;
    }
  }

  b[hook(1, index)] = (short)(res / sum);
}