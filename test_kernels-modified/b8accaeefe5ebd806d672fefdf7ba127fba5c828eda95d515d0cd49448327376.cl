//{"bigBlocks":5,"blockedGlobalPointIDs":1,"gVertexPositions":6,"globalVertexPositions":0,"startOffsetInPoint":2,"startOffsetInPointForBig":3,"vertexPositionsForBig":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BigBlockInitializationForPositions(global double* globalVertexPositions, global int* blockedGlobalPointIDs, global int* startOffsetInPoint, global int* startOffsetInPointForBig, global double* vertexPositionsForBig, global int* bigBlocks) {
  int workGroupID = get_group_id(0);

  int numOfThreads = get_local_size(0);

  int localID = get_local_id(0);

  int interestingBlockID = bigBlocks[hook(5, workGroupID)];

  global double* gVertexPositions;

  int startPoint = startOffsetInPoint[hook(2, interestingBlockID)];

  int numOfPoints = startOffsetInPoint[hook(2, interestingBlockID + 1)] - startPoint;

  int startPointForBig = startOffsetInPointForBig[hook(3, interestingBlockID)];

  gVertexPositions = vertexPositionsForBig + startPointForBig * 3;

  for (int i = localID; i < numOfPoints * 3; i += numOfThreads) {
    int localPointID = i / 3;
    int dimensionID = i % 3;
    int globalPointID = blockedGlobalPointIDs[hook(1, startPoint + localPointID)];

    gVertexPositions[hook(6, i)] = globalVertexPositions[hook(0, globalPointID * 3 + dimensionID)];
  }
}