//{"_segmentSizeBitShiftDivisor":7,"_segmentSizeModulor":6,"g_queryCt":3,"segmentSize":4,"segmentSizePow2":5,"tally":0,"tallyBuffer":2,"tallyCount":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void subtract_diff(global unsigned int* tally, global unsigned int* tallyCount, global unsigned int* tallyBuffer, global unsigned int* g_queryCt, unsigned int segmentSize, unsigned int segmentSizePow2, unsigned int _segmentSizeModulor, unsigned int _segmentSizeBitShiftDivisor) {
  unsigned int gIdx = get_global_id(0);
  unsigned int localQueueIdx = gIdx & _segmentSizeModulor;
  unsigned int queryIdx = gIdx >> _segmentSizeBitShiftDivisor;

  if (localQueueIdx < (g_queryCt[hook(3, queryIdx)] - 1)) {
    tallyCount[hook(1, gIdx)] = tallyBuffer[hook(2, gIdx + 1)] - tallyBuffer[hook(2, gIdx)];
  } else if (localQueueIdx == (g_queryCt[hook(3, queryIdx)] - 1)) {
    tallyCount[hook(1, gIdx)] = (queryIdx)*segmentSizePow2 + segmentSizePow2 - tallyBuffer[hook(2, gIdx)];
  }
}