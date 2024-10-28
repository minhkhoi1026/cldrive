//{"randomGPU":2,"randomNumbers":0,"randomsSeed":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int stepLCG(unsigned int* z, unsigned int A, unsigned int C) {
  return (*z) = (A * (*z) + C);
}

unsigned int stepLFG(unsigned int* z, global unsigned int* znmk, unsigned int A, unsigned int C) {
  return (*znmk) = (*z) = (A * (*z) + C) + (*znmk);
}

unsigned int stepCTG(unsigned int* z, unsigned int S1, unsigned int S2, unsigned int S3, unsigned int M) {
  unsigned int b = ((((*z) << S1) ^ (*z)) >> S2);
  return (*z) = ((((*z) & M) << S3) ^ b);
}

kernel void randomCTG(const int randomNumbers, global float2* randomsSeed, global float* randomGPU) {
  int id = get_global_id(0);
  int maxID = get_global_size(0);

  unsigned int rng1 = randomsSeed[hook(1, id)].x;
  unsigned int rng2 = randomsSeed[hook(1, id)].y;
  for (int i = 0; i < randomNumbers; ++i) {
    randomGPU[hook(2, id + i * maxID)] = (float)(stepCTG(&rng1, 13, 19, 12, 4294967294UL) ^ stepCTG(&rng2, 2, 25, 4, 4294967288UL)) / 0xffffffff;
  }
}