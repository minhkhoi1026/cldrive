//{"blockOfGroups":1,"numOfGroupsForBlocks":0,"offsetInBlocks":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void AssignGroups(global int* numOfGroupsForBlocks, global int* blockOfGroups, global int* offsetInBlocks) {
  int blockID = get_group_id(0);
  int threadID = get_local_id(0);
  int workSize = get_local_size(0);
  int startOffset = numOfGroupsForBlocks[hook(0, blockID)];
  int numOfGroups = numOfGroupsForBlocks[hook(0, blockID + 1)] - startOffset;

  for (int i = threadID; i < numOfGroups; i += workSize) {
    blockOfGroups[hook(1, startOffset + i)] = blockID;
    offsetInBlocks[hook(2, startOffset + i)] = i;
  }
}