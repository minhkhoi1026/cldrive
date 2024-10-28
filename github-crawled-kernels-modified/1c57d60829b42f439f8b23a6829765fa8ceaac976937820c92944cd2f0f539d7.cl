//{"aux":5,"data":0,"direction":3,"sharedMem":4,"stage":1,"subStage":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bitonicSort_sharedmem_2(global unsigned int* data, const unsigned int stage, const unsigned int subStage, const unsigned int direction, local unsigned int* sharedMem, local unsigned int* aux) {
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

  const unsigned int stride = 4;
  if (sortIncreasing) {
    aux[hook(5, threadId * stride)] = leftId;
    aux[hook(5, threadId * stride + 1)] = lesser;
    aux[hook(5, threadId * stride + 2)] = rightId;
    aux[hook(5, threadId * stride + 3)] = greater;
  } else {
    aux[hook(5, threadId * stride)] = leftId;
    aux[hook(5, threadId * stride + 1)] = greater;
    aux[hook(5, threadId * stride + 2)] = rightId;
    aux[hook(5, threadId * stride + 3)] = lesser;
  }
  barrier(0x01);

  if (threadId == 0) {
    for (int i = 0; i < 256 * stride; ++i) {
      data[hook(0, aux[ihook(5, i * stride))] = aux[hook(5, i * stride + 1)];
      data[hook(0, aux[ihook(5, i * stride + 2))] = aux[hook(5, i * stride + 3)];
    }
  }
}