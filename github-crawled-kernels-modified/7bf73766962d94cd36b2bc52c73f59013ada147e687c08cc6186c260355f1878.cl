//{"data":0,"direction":3,"sharedMem":4,"stage":1,"subStage":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bitonicSort_sharedmem(global unsigned int* data, const unsigned int stage, const unsigned int subStage, const unsigned int direction, local unsigned int* sharedMem) {
  unsigned int threadId = get_global_id(0);
  unsigned int sortIncreasing = direction;

  unsigned int distanceBetweenPairs = 1 << (stage - subStage);
  unsigned int blockWidth = distanceBetweenPairs << 1;

  unsigned int leftId = (threadId % distanceBetweenPairs) + (threadId / distanceBetweenPairs) * blockWidth;

  unsigned int rightId = leftId + distanceBetweenPairs;

  if (threadId == 0) {
    sharedMem[hook(4, threadId)] = data[hook(0, leftId)];
    sharedMem[hook(4, threadId + 1)] = data[hook(0, rightId)];
  } else {
    sharedMem[hook(4, threadId + 1)] = data[hook(0, leftId)];
    sharedMem[hook(4, threadId + 2)] = data[hook(0, rightId)];
  }
  barrier(0x01);

  unsigned int sameDirectionBlockWidth = 1 << stage;

  if ((threadId / sameDirectionBlockWidth) % 2 == 1)
    sortIncreasing = 1 - sortIncreasing;

  unsigned int greater;
  unsigned int lesser;

  if (threadId == 0) {
    if (sharedMem[hook(4, threadId)] > sharedMem[hook(4, threadId + 1)]) {
      greater = sharedMem[hook(4, threadId)];
      lesser = sharedMem[hook(4, threadId + 1)];
    } else {
      greater = sharedMem[hook(4, threadId + 1)];
      lesser = sharedMem[hook(4, threadId)];
    }
  } else {
    if (sharedMem[hook(4, threadId + 1)] > sharedMem[hook(4, threadId + 2)]) {
      greater = sharedMem[hook(4, threadId + 1)];
      lesser = sharedMem[hook(4, threadId + 2)];
    } else {
      greater = sharedMem[hook(4, threadId + 2)];
      lesser = sharedMem[hook(4, threadId + 1)];
    }
  }

  if (sortIncreasing) {
    data[hook(0, leftId)] = lesser;
    data[hook(0, rightId)] = greater;
  } else {
    data[hook(0, leftId)] = greater;
    data[hook(0, rightId)] = lesser;
  }
}