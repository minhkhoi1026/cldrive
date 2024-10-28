//{"direction":3,"partIdx":0,"passOfStage":2,"stage":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sph_kernel_sort(global uint2* partIdx, int stage, int passOfStage, int direction) {
  unsigned int sortIncreasing = direction;
  size_t threadId = get_global_id(0);

  unsigned int pairDistance = 1 << (stage - passOfStage);
  unsigned int blockWidth = 2 * pairDistance;

  unsigned int leftId = (threadId % pairDistance) + (threadId / pairDistance) * blockWidth;

  unsigned int rightId = leftId + pairDistance;

  uint2 leftElement = partIdx[hook(0, leftId)];
  uint2 rightElement = partIdx[hook(0, rightId)];

  unsigned int sameDirectionBlockWidth = 1 << stage;

  if ((threadId / sameDirectionBlockWidth) % 2 == 1)
    sortIncreasing = 1 - sortIncreasing;

  uint2 greater;
  uint2 lesser;
  if (leftElement.x > rightElement.x) {
    greater = leftElement;
    lesser = rightElement;
  } else {
    greater = rightElement;
    lesser = leftElement;
  }

  if (sortIncreasing) {
    partIdx[hook(0, leftId)] = lesser;
    partIdx[hook(0, rightId)] = greater;
  } else {
    partIdx[hook(0, leftId)] = greater;
    partIdx[hook(0, rightId)] = lesser;
  }
}