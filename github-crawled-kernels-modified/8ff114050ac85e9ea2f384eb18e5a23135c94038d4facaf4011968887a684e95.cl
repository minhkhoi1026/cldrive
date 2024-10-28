//{"buckets":1,"sharedArray":3,"shiftCount":2,"unsortedData":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histogram(global const unsigned int* unsortedData, global unsigned int* buckets, unsigned int shiftCount, local ushort* sharedArray) {
  size_t localId = get_local_id(0);
  size_t globalId = get_global_id(0);
  size_t groupId = get_group_id(0);
  size_t groupSize = get_local_size(0);

  for (int i = 0; i < (1 << 8); ++i)
    sharedArray[hook(3, localId * (1 << 8) + i)] = 0;

  barrier(0x01);

  for (int i = 0; i < (1 << 8); ++i) {
    unsigned int value = unsortedData[hook(0, globalId * (1 << 8) + i)];
    value = (value >> shiftCount) & 0xFFU;
    sharedArray[hook(3, localId * (1 << 8) + value)]++;
  }

  barrier(0x01);

  for (int i = 0; i < (1 << 8); ++i) {
    unsigned int bucketPos = groupId * (1 << 8) * groupSize + localId * (1 << 8) + i;
    buckets[hook(1, bucketPos)] = sharedArray[hook(3, localId * (1 << 8) + i)];
  }
}