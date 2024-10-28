//{"intSeeds":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int w_hash(unsigned int seed) {
  seed = (seed ^ 61) ^ (seed >> 16);
  seed *= 9;
  seed = seed ^ (seed >> 4);
  seed *= 0x27d4eb2d;
  seed = seed ^ (seed >> 15);
  return seed;
}

unsigned int w_rnd_direct(global unsigned int* intSeeds, int id) {
  unsigned int rndint = w_hash(intSeeds[hook(0, id)]);
  intSeeds[hook(0, id)] = rndint;
  return rndint;
}

unsigned int w_rnd_atomic(global unsigned int* intSeeds, int id) {
  unsigned int rndint = w_hash(intSeeds[hook(0, id)]);

  atomic_xchg(&intSeeds[hook(0, id)], rndint);
  return rndint;
}

kernel void testkernel(global unsigned int* intSeeds) {
  int id = get_global_id(0);
  unsigned int maxint = 0;
  maxint--;

  unsigned int result = w_rnd_atomic(intSeeds, id);

  if (result < maxint / 2) {
    w_rnd_atomic(intSeeds, id);

    w_rnd_atomic(intSeeds, id);
  }
}