//{"buckets":1,"data":0,"sharedArray":3,"shiftBy":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void computeHistogram(global const unsigned int* data, global unsigned int* buckets, unsigned int shiftBy, local unsigned int* sharedArray) {
  size_t localId = get_local_id(0);
  size_t globalId = get_global_id(0);
  size_t groupId = get_group_id(0);
  size_t groupSize = get_local_size(0);

  sharedArray[hook(3, localId)] = 0;
  barrier(0x01);

  unsigned int result = (data[hook(0, globalId)] >> shiftBy) & 0xFFU;
  atomic_inc(sharedArray + result);

  barrier(0x01);

  unsigned int bucketPos = groupId * groupSize + localId;
  buckets[hook(1, bucketPos)] = sharedArray[hook(3, localId)];
}