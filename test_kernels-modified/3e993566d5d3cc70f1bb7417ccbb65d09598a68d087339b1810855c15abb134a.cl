//{"localIndex":6,"scanedBuckets":2,"shiftCount":3,"sortedKeys":4,"sortedVals":5,"unsortedKeys":0,"unsortedVals":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__inline unsigned int convertKey(unsigned int converted_key) {
  return converted_key;
}

kernel void permuteRadixN(global float* unsortedKeys, global float* unsortedVals, global int* scanedBuckets, unsigned int shiftCount, global float* sortedKeys, global float* sortedVals) {
  const int RADIX_T = 4;
  const int RADICES_T = (1 << RADIX_T);
  const int MASK_T = (1 << RADIX_T) - 1;

  int globalId = get_global_id(0);
  int numOfGroups = get_num_groups(0);
  const int NUM_OF_ELEMENTS_PER_WORK_GROUP_T = numOfGroups << 4;
  int localIndex[16];

  for (int i = 0; i < RADICES_T; ++i) {
    localIndex[hook(6, i)] = scanedBuckets[hook(2, mad24(i, NUM_OF_ELEMENTS_PER_WORK_GROUP_T, globalId))];
  }

  for (int i = 0; i < RADICES_T; ++i) {
    int old_idx = mad24(globalId, RADICES_T, i);
    float ovalue = unsortedKeys[hook(0, old_idx)];
    unsigned int value = convertKey(__builtin_astype((ovalue), unsigned int));
    unsigned int maskedValue = (value >> shiftCount) & MASK_T;
    unsigned int index = localIndex[hook(6, maskedValue)];
    sortedKeys[hook(4, index)] = ovalue;
    sortedVals[hook(5, index)] = unsortedVals[hook(1, old_idx)];
    localIndex[hook(6, maskedValue)] = index + 1;
  }
}