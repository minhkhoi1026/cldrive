//{"bigBlocks":7,"blockedGlobalPointIDs":2,"endVelocitiesForBig":6,"gEndVelocities":9,"gStartVelocities":8,"globalEndVelocities":1,"globalStartVelocities":0,"startOffsetInPoint":3,"startOffsetInPointForBig":4,"startVelocitiesForBig":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BigBlockInitializationForVelocities(global double* globalStartVelocities, global double* globalEndVelocities, global int* blockedGlobalPointIDs, global int* startOffsetInPoint, global int* startOffsetInPointForBig, global double* startVelocitiesForBig, global double* endVelocitiesForBig, global int* bigBlocks) {
  int workGroupID = get_group_id(0);

  int numOfThreads = get_local_size(0);

  int localID = get_local_id(0);

  int interestingBlockID = bigBlocks[hook(7, workGroupID)];

  global double* gStartVelocities;
  global double* gEndVelocities;

  int startPoint = startOffsetInPoint[hook(3, interestingBlockID)];

  int numOfPoints = startOffsetInPoint[hook(3, interestingBlockID + 1)] - startPoint;

  int startPointForBig = startOffsetInPointForBig[hook(4, interestingBlockID)];

  gStartVelocities = startVelocitiesForBig + startPointForBig * 3;
  gEndVelocities = endVelocitiesForBig + startPointForBig * 3;

  for (int i = localID; i < numOfPoints * 3; i += numOfThreads) {
    int localPointID = i / 3;
    int dimensionID = i % 3;
    int globalPointID = blockedGlobalPointIDs[hook(2, startPoint + localPointID)];

    gStartVelocities[hook(8, i)] = globalStartVelocities[hook(0, globalPointID * 3 + dimensionID)];
    gEndVelocities[hook(9, i)] = globalEndVelocities[hook(1, globalPointID * 3 + dimensionID)];
  }
}