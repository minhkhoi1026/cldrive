//{"bitMask":4,"count":3,"doWriteTotalFalses":5,"elements":2,"prefixSums":0,"sums":1,"totalFalses":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant size_t ELEMENTS_PER_WORK_ITEM_SCAN = 2;
constant size_t ELEMENTS_PER_WORK_ITEM_OTHERS = 2;
kernel void addGroupPrefix(global unsigned int* prefixSums, global unsigned int* sums, global unsigned int* elements, const unsigned int count, const unsigned int bitMask, const unsigned int doWriteTotalFalses, global unsigned int* totalFalses) {
  size_t i = get_local_id(0);
  size_t group = get_group_id(0);
  size_t groupSize = get_local_size(0);

  size_t groupOffset = group * groupSize * ELEMENTS_PER_WORK_ITEM_OTHERS;

  size_t itemOffset = ELEMENTS_PER_WORK_ITEM_OTHERS * i;

  prefixSums[hook(0, groupOffset + itemOffset)] += sums[hook(1, group)];
  prefixSums[hook(0, groupOffset + itemOffset + 1)] += sums[hook(1, group)];

  barrier(0x02);

  if ((get_local_id(0) == 0) && (group == (get_num_groups(0) - 1))) {
    if (doWriteTotalFalses) {
      unsigned int lastIndex = count - 1;

      totalFalses[hook(6, 0)] = !(elements[hook(2, lastIndex)] & bitMask) + prefixSums[hook(0, lastIndex)];
    }
  }
}