//{"activeBlockIndices":5,"activeParticles":3,"blockLocations":4,"blockedParticleList":6,"blocksOfTets":10,"localIDsOfTets":11,"numOfActiveParticles":8,"numOfParticlesByStageInBlocks":0,"numOfStages":7,"particleOrders":1,"stages":2,"startOffsetsInLocalIDMap":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int Sign(double a, double eps) {
  return a < -eps ? -1 : a > eps;
}

inline int GetLocalTetID(int blockID, int tetID, global int* startOffsetsInLocalIDMap, global int* blocksOfTets, global int* localIDsOfTets) {
  int offset = startOffsetsInLocalIDMap[hook(9, tetID)];
  int endOffset = -1;
  while (1) {
    if (blocksOfTets[hook(10, offset)] == blockID)
      return localIDsOfTets[hook(11, offset)];
    if (endOffset == -1)
      endOffset = startOffsetsInLocalIDMap[hook(9, tetID + 1)];

    offset++;
    if (offset >= endOffset)
      return -1;
  }
}

inline int GetBlockID(int x, int y, int z, int numOfBlocksInY, int numOfBlocksInZ) {
  return (x * numOfBlocksInY + y) * numOfBlocksInZ + z;
}

kernel void CollectParticlesToBlocks(global int* numOfParticlesByStageInBlocks, global int* particleOrders, global int* stages, global int* activeParticles, global int* blockLocations, global int* activeBlockIndices,

                                     global int* blockedParticleList, int numOfStages, int numOfActiveParticles) {
  int globalID = get_global_id(0);

  if (globalID < numOfActiveParticles) {
    int particleID = activeParticles[hook(3, globalID)];

    int interestingBlockID = blockLocations[hook(4, particleID)];
    int activeBlockID = activeBlockIndices[hook(5, interestingBlockID)];
    int stage = stages[hook(2, particleID)];

    int position = numOfParticlesByStageInBlocks[hook(0, activeBlockID * numOfStages + stage)] + particleOrders[hook(1, particleID)];

    blockedParticleList[hook(6, position)] = particleID;
  }
}