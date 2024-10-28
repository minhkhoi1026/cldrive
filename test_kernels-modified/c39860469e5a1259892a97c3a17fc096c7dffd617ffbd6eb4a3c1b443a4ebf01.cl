//{"passOfStage":2,"stage":1,"theArray":0,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bitonicSort(global unsigned int* theArray, const unsigned int stage, const unsigned int passOfStage, const unsigned int width) {
  unsigned int sortIncreasing = 1;
  unsigned int threadId = get_global_id(0);

  unsigned int pairDistance = 1 << (stage - passOfStage);
  unsigned int blockWidth = 2 * pairDistance;

  unsigned int leftId = (threadId % pairDistance) + (threadId / pairDistance) * blockWidth;

  unsigned int rightId = leftId + pairDistance;

  unsigned int leftElement = theArray[hook(0, leftId)];
  unsigned int rightElement = theArray[hook(0, rightId)];

  unsigned int sameDirectionBlockWidth = 1 << stage;

  if ((threadId / sameDirectionBlockWidth) % 2 == 1) {
    sortIncreasing = 1 - sortIncreasing;
  }

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
    theArray[hook(0, leftId)] = lesser;
    theArray[hook(0, rightId)] = greater;
  } else {
    theArray[hook(0, leftId)] = greater;
    theArray[hook(0, rightId)] = lesser;
  }
}