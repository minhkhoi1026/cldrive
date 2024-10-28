//{"binResult":2,"data":0,"sharedArray":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histogram256(global const unsigned int* data, local uchar* sharedArray, global unsigned int* binResult) {
  size_t localId = get_local_id(0);
  size_t globalId = get_global_id(0);
  size_t groupId = get_group_id(0);
  size_t groupSize = get_local_size(0);

  for (int i = 0; i < 256; ++i)
    sharedArray[hook(1, localId * 256 + i)] = 0;

  barrier(0x01);

  for (int i = 0; i < 256; ++i) {
    unsigned int value = data[hook(0, groupId * groupSize * 256 + i * groupSize + localId)];

    sharedArray[hook(1, localId * 256 + value)]++;
  }

  barrier(0x01);

  for (int i = 0; i < 256 / groupSize; ++i) {
    unsigned int binCount = 0;
    for (int j = 0; j < groupSize; ++j)
      binCount += sharedArray[hook(1, j * 256 + i * groupSize + localId)];

    binResult[hook(2, groupId * 256 + i * groupSize + localId)] = binCount;
  }
}