//{"bestPerson":2,"bestWeights":0,"motions":1,"seed":6,"sizeIn":4,"sizeOut":5,"weights":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float rand(const ulong seed) {
  return (float)(((seed * 0x5DEECE66DL + 0xBL) & ((1L << 48) - 1)) >> 16) / 0x10000000f;
}

ulong next(const ulong seed) {
  return ((seed * 0x5DEECE66DL + 0xBL) & ((1L << 48) - 1)) >> 16;
}

kernel void update(constant float* bestWeights, global float* motions, constant float* bestPerson, global float* weights, const unsigned int sizeIn, const unsigned int sizeOut, ulong seed) {
  const unsigned int personId = get_global_id(0);
  const unsigned int inputsId = get_global_id(1);
  const unsigned int size = sizeIn * sizeOut;
  const lastId = personId * size + (inputsId + 1) * sizeOut;

  for (unsigned int id = lastId - sizeOut, bestId = inputsId * sizeOut; id < lastId; ++id, ++bestId, seed = next(seed)) {
    motions[hook(1, id)] = 0.95f * motions[hook(1, id)] + 0.1f * rand(id) * (bestWeights[hook(0, id)] - weights[hook(3, id)]) + 0.2f * rand(id ^ 1) * (bestPerson[hook(2, bestId)] - weights[hook(3, id)]);

    weights[hook(3, id)] += motions[hook(1, id)] + weights[hook(3, id)] * (2 * rand(seed - id) - 1) * 0.01f;
  }
  return;
}