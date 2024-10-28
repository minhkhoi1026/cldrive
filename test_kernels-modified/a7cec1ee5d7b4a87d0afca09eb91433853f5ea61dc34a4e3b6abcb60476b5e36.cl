//{"scannedHistogram":1,"sharedBuckets":3,"shiftCount":2,"sortedData":4,"unsortedData":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rankNPermute(global const unsigned int* unsortedData, global const unsigned int* scannedHistogram, unsigned int shiftCount, local ushort* sharedBuckets, global unsigned int* sortedData) {
  size_t groupId = get_group_id(0);
  size_t idx = get_local_id(0);
  size_t gidx = get_global_id(0);
  size_t groupSize = get_local_size(0);

  for (int i = 0; i < (1 << 8); ++i) {
    unsigned int bucketPos = groupId * (1 << 8) * groupSize + idx * (1 << 8) + i;
    sharedBuckets[hook(3, idx * (1 << 8) + i)] = scannedHistogram[hook(1, bucketPos)];
  }

  barrier(0x01);

  for (int i = 0; i < (1 << 8); ++i) {
    unsigned int value = unsortedData[hook(0, gidx * (1 << 8) + i)];
    value = (value >> shiftCount) & 0xFFU;
    unsigned int index = sharedBuckets[hook(3, idx * (1 << 8) + value)];
    sortedData[hook(4, index)] = unsortedData[hook(0, gidx * (1 << 8) + i)];
    sharedBuckets[hook(3, idx * (1 << 8) + value)] = index + 1;
    barrier(0x01);
  }
}