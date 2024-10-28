//{"buckets":1,"localBuckets":3,"shiftCount":2,"unsortedKeys":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__inline unsigned int convertKey(unsigned int converted_key) {
  return converted_key;
}

kernel void histogramRadixN(global float* unsortedKeys, global int* buckets, unsigned int shiftCount) {
  const int RADIX_T = 4;
  const int RADICES_T = (1 << RADIX_T);
  const int NUM_OF_ELEMENTS_PER_WORK_ITEM_T = RADICES_T;
  const int MASK_T = (1 << RADIX_T) - 1;
  int localBuckets[16] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
  int globalId = get_global_id(0);
  int numOfGroups = get_num_groups(0);

  for (int i = 0; i < NUM_OF_ELEMENTS_PER_WORK_ITEM_T; ++i) {
    unsigned int value = convertKey(__builtin_astype((unsortedKeys[hook(0, mad24(globalId, NUM_OF_ELEMENTS_PER_WORK_ITEM_T, i))]), unsigned int));
    value = (value >> shiftCount) & MASK_T;

    localBuckets[hook(3, value)]++;
  }

  for (int i = 0; i < NUM_OF_ELEMENTS_PER_WORK_ITEM_T; ++i) {
    buckets[hook(1, mad24(i, RADICES_T * numOfGroups, globalId))] = localBuckets[hook(3, i)];
  }
}