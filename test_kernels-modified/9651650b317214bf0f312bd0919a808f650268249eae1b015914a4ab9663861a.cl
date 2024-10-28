//{"randomGPU":2,"randomNumbers":0,"randomsSeed":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int stepLCG(unsigned int* z, unsigned int A, unsigned int C) {
  return (*z) = (A * (*z) + C);
}

kernel void randomLCG(const int randomNumbers, global float* randomsSeed, global float* randomGPU) {
  int id = get_global_id(0);
  int maxID = get_global_size(0);

  unsigned int rng = randomsSeed[hook(1, id)];
  for (int i = 0; i < randomNumbers; ++i) {
    randomGPU[hook(2, id + i * maxID)] = (float)stepLCG(&rng, 1664525, 1013904223UL) / 0xffffffff;
  }
}