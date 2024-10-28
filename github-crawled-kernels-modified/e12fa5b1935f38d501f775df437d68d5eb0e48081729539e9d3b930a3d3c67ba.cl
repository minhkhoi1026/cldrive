//{"dst":0,"k":2,"seed":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
uint2 rand(uint2 seed, unsigned int iterations) {
  unsigned int sum = 0;
  unsigned int delta = 0x9E3779B9;
  unsigned int k[4] = {0xA341316C, 0xC8013EA4, 0xAD90777D, 0x7E95761E};

  for (int j = 0; j < iterations; j++) {
    sum += delta;
    seed.x += ((seed.y << 4) + k[hook(2, 0)]) & (seed.y + sum) & ((seed.y >> 5) + k[hook(2, 1)]);
    seed.y += ((seed.x << 4) + k[hook(2, 2)]) & (seed.x + sum) & ((seed.x >> 5) + k[hook(2, 3)]);
  }

  return seed;
}
constant unsigned int ITER = 15;
kernel void clRandom1D(global uchar4* dst, unsigned int seed) {
  unsigned int x = get_global_id(0);
  uint2 rnd = (uint2)(seed, seed << 3);
  rnd.x += x + (x << 11) + (x << 19);
  rnd.y += x + (x << 9) + (x << 21);
  rnd = rand(rnd, ITER);
  uchar r = rnd.x & 0xff;
  float alpha = (rnd.x & 0xff00) >> 8;
  dst[hook(0, x)] = (uchar4)(r, r, r, alpha);
}