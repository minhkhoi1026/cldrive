//{"bitMask":5,"count":1,"doWriteSums":4,"doWriteTotalFalses":7,"elements":0,"prefixSums":6,"sums":3,"temp":2,"totalFalses":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant size_t ELEMENTS_PER_WORK_ITEM_SCAN = 2;
constant size_t ELEMENTS_PER_WORK_ITEM_OTHERS = 2;
kernel void prefixSumScan(global unsigned int* elements, const unsigned int count, local unsigned int* temp, global unsigned int* sums, const unsigned int doWriteSums, const unsigned int bitMask, global unsigned int* prefixSums, const unsigned int doWriteTotalFalses, global unsigned int* totalFalses) {
  size_t i = get_local_id(0);
  size_t group = get_group_id(0);
  size_t groupSize = get_local_size(0);

  size_t elementsPerGroup = groupSize * ELEMENTS_PER_WORK_ITEM_SCAN;

  size_t groupOffset = group * elementsPerGroup;

  size_t itemOffset = ELEMENTS_PER_WORK_ITEM_SCAN * i;
  if (bitMask == 0) {
    temp[hook(2, itemOffset)] = elements[hook(0, groupOffset + itemOffset)];
    temp[hook(2, itemOffset + 1)] = elements[hook(0, groupOffset + itemOffset + 1)];
  } else {
    temp[hook(2, itemOffset)] = !(elements[hook(0, groupOffset + itemOffset)] & bitMask);
    temp[hook(2, itemOffset + 1)] = !(elements[hook(0, groupOffset + itemOffset + 1)] & bitMask);
  }

  int offset = 1;

  size_t binaryOffset = i * 2;

  for (int d = elementsPerGroup >> 1; d > 0; d >>= 1) {
    barrier(0x01);

    if (i < d) {
      int a = offset * (binaryOffset + 1) - 1;
      int b = offset * (binaryOffset + 2) - 1;

      temp[hook(2, b)] += temp[hook(2, a)];
    }

    offset *= 2;
  }

  barrier(0x01);

  if (get_local_id(0) == 0) {
    if (doWriteSums) {
      sums[hook(3, group)] = temp[hook(2, elementsPerGroup - 1)];
    }

    temp[hook(2, elementsPerGroup - 1)] = 0;
  }

  for (int d = 1; d < elementsPerGroup; d *= 2) {
    offset >>= 1;

    barrier(0x01);

    if (i < d) {
      int a = offset * (binaryOffset + 1) - 1;
      int b = offset * (binaryOffset + 2) - 1;

      unsigned int t = temp[hook(2, a)];
      temp[hook(2, a)] = temp[hook(2, b)];
      temp[hook(2, b)] += t;
    }
  }

  barrier(0x01);

  if (get_global_id(0) == 0) {
    if (doWriteTotalFalses) {
      unsigned int lastIndex = count - 1;

      totalFalses[hook(8, 0)] = !(elements[hook(0, lastIndex)] & bitMask) + temp[hook(2, lastIndex)];
    }
  }

  prefixSums[hook(6, groupOffset + itemOffset)] = temp[hook(2, itemOffset)];
  prefixSums[hook(6, groupOffset + itemOffset + 1)] = temp[hook(2, itemOffset + 1)];
}