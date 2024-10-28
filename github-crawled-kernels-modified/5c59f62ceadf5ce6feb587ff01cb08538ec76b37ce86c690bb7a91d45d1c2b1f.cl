//{"groupSize":3,"numOfActiveBlocks":2,"numOfGroupsForBlocks":1,"startOffsetInParticles":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void GetNumOfGroupsForBlocks(global int* startOffsetInParticles, global int* numOfGroupsForBlocks, int numOfActiveBlocks, int groupSize) {
  int globalID = get_global_id(0);
  if (globalID < numOfActiveBlocks) {
    int numOfParticles = startOffsetInParticles[hook(0, globalID + 1)] - startOffsetInParticles[hook(0, globalID)];
    numOfGroupsForBlocks[hook(1, globalID)] = (numOfParticles - 1) / groupSize + 1;
  }
}