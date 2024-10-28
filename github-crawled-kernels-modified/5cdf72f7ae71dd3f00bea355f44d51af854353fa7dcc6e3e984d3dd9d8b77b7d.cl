//{"activeBlockIndices":5,"activeParticles":3,"blockLocations":4,"blocksOfTets":9,"localIDsOfTets":10,"numOfActiveParticles":7,"numOfParticlesByStageInBlocks":0,"numOfStages":6,"particleOrders":1,"stages":2,"startOffsetsInLocalIDMap":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int Sign(double a, double eps) {
  return a < -eps ? -1 : a > eps;
}

inline int GetLocalTetID(int blockID, int tetID, global int* startOffsetsInLocalIDMap, global int* blocksOfTets, global int* localIDsOfTets) {
  int offset = startOffsetsInLocalIDMap[hook(8, tetID)];
  int endOffset = -1;
  while (1) {
    if (blocksOfTets[hook(9, offset)] == blockID)
      return localIDsOfTets[hook(10, offset)];
    if (endOffset == -1)
      endOffset = startOffsetsInLocalIDMap[hook(8, tetID + 1)];

    offset++;
    if (offset >= endOffset)
      return -1;
  }
}

inline int GetBlockID(int x, int y, int z, int numOfBlocksInY, int numOfBlocksInZ) {
  return (x * numOfBlocksInY + y) * numOfBlocksInZ + z;
}

kernel void GetNumOfParticlesByStageInBlocks(volatile global int* numOfParticlesByStageInBlocks, global int* particleOrders, global int* stages, global int* activeParticles,

                                             global int* blockLocations, global int* activeBlockIndices, int numOfStages, int numOfActiveParticles) {
  int globalID = get_global_id(0);
  if (globalID < numOfActiveParticles) {
    int particleID = activeParticles[hook(3, globalID)];

    int posi = activeBlockIndices[hook(5, blockLocations[phook(4, particleID))] * numOfStages + stages[hook(2, particleID)];
    particleOrders[hook(1, particleID)] = atomic_add(numOfParticlesByStageInBlocks + posi, 1);
  }
}