//{"binResult":2,"binSize":3,"data":0,"sharedArray":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histogram256(global const uchar* data, local uchar* sharedArray, global unsigned int* binResult, unsigned int binSize) {
  size_t localId = get_local_id(0);
  size_t globalId = get_global_id(0);
  size_t groupId = get_group_id(0);
  size_t groupSize = get_local_size(0);

  for (int i = 0; i < binSize; ++i)
    sharedArray[hook(1, localId * binSize + i)] = 0;

  barrier(0x01);

  for (int i = 0; i < binSize; ++i) {
    uchar value = data[hook(0, groupId * groupSize * binSize + i * groupSize + localId)];

    sharedArray[hook(1, localId * binSize + value)]++;
  }

  barrier(0x01);

  for (int i = 0; i < binSize / groupSize; ++i) {
    unsigned int binCount = 0;
    for (int j = 0; j < groupSize; ++j)
      binCount += sharedArray[hook(1, j * binSize + i * groupSize + localId)];

    binResult[hook(2, groupId * binSize + i * groupSize + localId)] = binCount;
  }
}