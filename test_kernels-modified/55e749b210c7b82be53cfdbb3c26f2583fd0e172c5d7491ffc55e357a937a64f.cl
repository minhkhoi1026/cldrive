//{"data":0,"direction":3,"stage":1,"subStage":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bitonicSort(global unsigned int* data, const unsigned int stage, const unsigned int subStage, const unsigned int direction) {
  unsigned int threadId = get_global_id(0);
  unsigned int sortIncreasing = direction;

  unsigned int distanceBetweenPairs = 1 << (stage - subStage);
  unsigned int blockWidth = distanceBetweenPairs << 1;

  unsigned int leftId = (threadId % distanceBetweenPairs) + (threadId / distanceBetweenPairs) * blockWidth;

  unsigned int rightId = leftId + distanceBetweenPairs;

  unsigned int leftElement = data[hook(0, leftId)];
  unsigned int rightElement = data[hook(0, rightId)];

  unsigned int sameDirectionBlockWidth = 1 << stage;

  if ((threadId / sameDirectionBlockWidth) % 2 == 1)
    sortIncreasing = 1 - sortIncreasing;

  unsigned int greater;
  unsigned int lesser;
  if (leftElement > rightElement) {
    greater = leftElement;
    lesser = rightElement;
  } else {
    greater = rightElement;
    lesser = leftElement;
  }

  if (sortIncreasing) {
    data[hook(0, leftId)] = lesser;
    data[hook(0, rightId)] = greater;
  } else {
    data[hook(0, leftId)] = greater;
    data[hook(0, rightId)] = lesser;
  }
}