//{"aabbs":0,"aabbsCount":1,"globalIndex":2,"indexes":3,"output":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sweepAndPrune(global float* aabbs, constant size_t* aabbsCount, global size_t* globalIndex, global size_t* indexes, global size_t* output) {
 private
  size_t elementsPerWorkItem = *aabbsCount / get_global_size(0);
 private
  size_t inputThreadIndex = get_global_id(0) * elementsPerWorkItem;
 private
  size_t outputIndex = 0;

  for (size_t i = inputThreadIndex; i < inputThreadIndex + elementsPerWorkItem; i++) {
    for (size_t j = i + 1; j < *aabbsCount; j++) {
      if (aabbs[hook(0, indexes[ihook(3, i) * 8 + 1 + 4)] < aabbs[hook(0, indexes[jhook(3, j) * 8 + 1 + 1)])
        break;

      if (aabbs[hook(0, indexes[ihook(3, i) * 8 + 1 + 5)] >= aabbs[hook(0, indexes[jhook(3, j) * 8 + 1 + 2)] && aabbs[hook(0, indexes[ihook(3, i) * 8 + 1 + 2)] <= aabbs[hook(0, indexes[jhook(3, j) * 8 + 1 + 5)] && aabbs[hook(0, indexes[ihook(3, i) * 8 + 1 + 6)] >= aabbs[hook(0, indexes[jhook(3, j) * 8 + 1 + 3)] && aabbs[hook(0, indexes[ihook(3, i) * 8 + 1 + 3)] <= aabbs[hook(0, indexes[jhook(3, j) * 8 + 1 + 6)]) {
        outputIndex = atomic_add(globalIndex, 2);
        output[hook(4, outputIndex)] = i;
        output[hook(4, outputIndex + 1)] = j;
      }
    }
  }
}