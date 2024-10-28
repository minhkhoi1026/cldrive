//{"randomGPU":4,"randomNumbers":0,"randomState":3,"randomStateSize":2,"randomsSeed":1}
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

kernel void randomLFG(const int randomNumbers, global float* randomsSeed, const int randomStateSize, global unsigned int* randomState, global float* randomGPU) {
  int id = get_global_id(0);
  int maxID = get_global_size(0);

  unsigned int rng = randomsSeed[hook(1, id)];
  for (int i = 0; i < randomStateSize; ++i) {
    randomState[hook(3, id + i * maxID)] = stepLCG(&rng, 1664525, 1013904223UL);
  }

  int nmkIndex = 0;
  for (int i = 0; i < randomNumbers; ++i) {
    randomGPU[hook(4, id + i * maxID)] = (float)stepLFG(&rng, &randomState[hook(3, nmkIndex)], 1664525, 1013904223UL) / 0xffffffff;
    nmkIndex = (nmkIndex + 1) % randomStateSize;
  }
}