//{"output":1,"seeds":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gen_numbers(global uint4* seeds, global unsigned int* output) {
  const unsigned int iWorkItem = get_global_id(0);

  unsigned int nNumbersInThisWorkItem = (0 / get_global_size(0));
  if (iWorkItem == get_global_size(0) - 1)
    nNumbersInThisWorkItem += (0 - (0 / get_global_size(0)) * get_global_size(0));
  output += iWorkItem * (0 / get_global_size(0));

  uint4 seed = seeds[hook(0, iWorkItem)];

  unsigned int x = seed.x, y = seed.y, z = seed.z, w = seed.w;
  for (unsigned int i = 0; i < nNumbersInThisWorkItem; i++) {
    unsigned int t = x ^ (x << 11);
    x = y;
    y = z;
    z = w;

    *(output++) = w = (w ^ (w >> 19)) ^ (t ^ (t >> 8));
  }

  seeds[hook(0, iWorkItem)] = (uint4)(x, y, z, w);
}