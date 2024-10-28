//{"bestErrors":1,"bestWeights":3,"errors":0,"size":4,"weights":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calculate_best_error(constant float* errors, global float* bestErrors, constant float* weights, global float* bestWeights, const unsigned int size) {
  const unsigned int personId = get_global_id(0);
  const unsigned int lastId = (personId + 1) * size;

  if (errors[hook(0, personId)] <= bestErrors[hook(1, personId)]) {
    bestErrors[hook(1, personId)] = errors[hook(0, personId)];
    for (unsigned int id = lastId - size; id < lastId; ++id) {
      bestWeights[hook(3, id)] = weights[hook(2, id)];
    }
  }
  return;
}