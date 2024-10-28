//{"bestWeights":1,"personId":4,"sizeIn":2,"sizeOut":3,"weights":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy_best_person(constant float* weights, global float* bestWeights, const unsigned int sizeIn, const unsigned int sizeOut, const unsigned int personId) {
  const unsigned int inputId = get_global_id(0);

  const unsigned int lastId = personId * sizeIn * sizeOut + (inputId + 1) * sizeOut;
  for (unsigned int id = lastId - sizeOut, bestId = inputId * sizeOut; id < lastId; ++id, ++bestId) {
    bestWeights[hook(1, bestId)] = weights[hook(0, id)];
  }
  return;
}