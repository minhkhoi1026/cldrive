//{"bitMask":4,"count":1,"elements":0,"elementsOut":5,"prefixSums":2,"totalFalses":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant size_t ELEMENTS_PER_WORK_ITEM_SCAN = 2;
constant size_t ELEMENTS_PER_WORK_ITEM_OTHERS = 2;
kernel void computeIndexAndScatter(global unsigned int* elements, const unsigned int count, global unsigned int* prefixSums, global unsigned int* totalFalses, const unsigned int bitMask, global unsigned int* elementsOut) {
  size_t i = get_local_id(0);
  size_t group = get_group_id(0);
  size_t groupSize = get_local_size(0);

  size_t groupOffset = group * groupSize * ELEMENTS_PER_WORK_ITEM_OTHERS;

  size_t itemOffset = ELEMENTS_PER_WORK_ITEM_OTHERS * i;

  size_t i0 = groupOffset + itemOffset;
  size_t i1 = groupOffset + itemOffset + 1;

  size_t f0 = prefixSums[hook(2, i0)];
  size_t f1 = prefixSums[hook(2, i1)];

  unsigned int totalFalsesCount = totalFalses[hook(3, 0)];

  unsigned int t0 = i0 - f0 + totalFalsesCount;
  unsigned int t1 = i1 - f1 + totalFalsesCount;

  unsigned int d0 = (elements[hook(0, i0)] & bitMask) ? t0 : f0;
  unsigned int d1 = (elements[hook(0, i1)] & bitMask) ? t1 : f1;

  unsigned int lastIndex = count - 1;

  if (i0 <= lastIndex) {
    elementsOut[hook(5, d0)] = elements[hook(0, i0)];

    if (i1 <= lastIndex) {
      elementsOut[hook(5, d1)] = elements[hook(0, i1)];

      {
        {}
      }
    }
  }
}