//{"_segmentSizeModulor":3,"segmentSize":2,"tally":0,"tallyCount":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mark_diff(global unsigned int* tally, global unsigned int* tallyCount, unsigned int segmentSize, unsigned int _segmentSizeModulor) {
  unsigned int gIdx = get_global_id(0);
  unsigned int localQueueIdx = gIdx & _segmentSizeModulor;

  if (localQueueIdx != 0) {
    tallyCount[hook(1, gIdx)] = (tally[hook(0, gIdx)] != tally[hook(0, gIdx - 1)]) ? gIdx : -1;
  } else {
    tallyCount[hook(1, gIdx)] = gIdx;
  }
}