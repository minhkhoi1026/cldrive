//{"bigBlocks":9,"blockedGlobalPointIDs":3,"endVelocitiesForBig":8,"gEndVelocities":12,"gStartVelocities":11,"gVertexPositions":10,"globalEndVelocities":2,"globalStartVelocities":1,"globalVertexPositions":0,"startOffsetInPoint":4,"startOffsetInPointForBig":5,"startVelocitiesForBig":7,"vertexPositionsForBig":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BigBlockInitialization(global double* globalVertexPositions, global double* globalStartVelocities, global double* globalEndVelocities, global int* blockedGlobalPointIDs, global int* startOffsetInPoint, global int* startOffsetInPointForBig, global double* vertexPositionsForBig, global double* startVelocitiesForBig, global double* endVelocitiesForBig, global int* bigBlocks) {
  int workGroupID = get_group_id(0);

  int numOfThreads = get_local_size(0);

  int localID = get_local_id(0);

  int interestingBlockID = bigBlocks[hook(9, workGroupID)];

  global double* gVertexPositions;
  global double* gStartVelocities;
  global double* gEndVelocities;

  int startPoint = startOffsetInPoint[hook(4, interestingBlockID)];

  int numOfPoints = startOffsetInPoint[hook(4, interestingBlockID + 1)] - startPoint;

  int startPointForBig = startOffsetInPointForBig[hook(5, interestingBlockID)];

  gVertexPositions = vertexPositionsForBig + startPointForBig * 3;
  gStartVelocities = startVelocitiesForBig + startPointForBig * 3;
  gEndVelocities = endVelocitiesForBig + startPointForBig * 3;

  for (int i = localID; i < numOfPoints * 3; i += numOfThreads) {
    int localPointID = i / 3;
    int dimensionID = i % 3;
    int globalPointID = blockedGlobalPointIDs[hook(3, startPoint + localPointID)];

    gVertexPositions[hook(10, i)] = globalVertexPositions[hook(0, globalPointID * 3 + dimensionID)];
    gStartVelocities[hook(11, i)] = globalStartVelocities[hook(1, globalPointID * 3 + dimensionID)];
    gEndVelocities[hook(12, i)] = globalEndVelocities[hook(2, globalPointID * 3 + dimensionID)];
  }
}