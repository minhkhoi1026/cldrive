//{"buffer":0,"offset":1,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void global_prefixSum(global unsigned int* buffer, const int offset, const int size) {
  int localSize = get_local_size(0);
  int groupIdx = get_group_id(0);

  int sortedLocalBlocks = offset / localSize;

  int gidToUnsortedBlocks = groupIdx + (groupIdx / ((offset << 1) - sortedLocalBlocks) + 1) * sortedLocalBlocks;

  int globalIdx = (gidToUnsortedBlocks * localSize + get_local_id(0));
  if (((globalIdx + 1) % offset != 0) && (globalIdx < size))
    buffer[hook(0, globalIdx)] += buffer[hook(0, globalIdx - (globalIdx % offset + 1))];
}