//{"activeBlockIndices":11,"activeBlocks":10,"activeParticles":0,"blockLocations":4,"blockSize":21,"blocksOfTets":7,"dx":23,"dy":24,"dz":25,"epsilon":22,"exitCells":1,"globalMinX":18,"globalMinY":19,"globalMinZ":20,"interestingBlockMap":5,"interestingBlockMarks":9,"localIDsOfTets":8,"localTetIDs":3,"mark":13,"numOfActiveBlocks":12,"numOfActiveParticles":14,"numOfBlocksInX":15,"numOfBlocksInY":16,"numOfBlocksInZ":17,"placesOfInterest":2,"startOffsetsInLocalIDMap":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int Sign(double a, double eps) {
  return a < -eps ? -1 : a > eps;
}

inline int GetLocalTetID(int blockID, int tetID, global int* startOffsetsInLocalIDMap, global int* blocksOfTets, global int* localIDsOfTets) {
  int offset = startOffsetsInLocalIDMap[hook(6, tetID)];
  int endOffset = -1;
  while (1) {
    if (blocksOfTets[hook(7, offset)] == blockID)
      return localIDsOfTets[hook(8, offset)];
    if (endOffset == -1)
      endOffset = startOffsetsInLocalIDMap[hook(6, tetID + 1)];

    offset++;
    if (offset >= endOffset)
      return -1;
  }
}

inline int GetBlockID(int x, int y, int z, int numOfBlocksInY, int numOfBlocksInZ) {
  return (x * numOfBlocksInY + y) * numOfBlocksInZ + z;
}

kernel void CollectActiveBlocks(global int* activeParticles, global int* exitCells,

                                global double* placesOfInterest,

                                global int* localTetIDs, global int* blockLocations,

                                global int* interestingBlockMap,

                                global int* startOffsetsInLocalIDMap, global int* blocksOfTets, global int* localIDsOfTets,

                                volatile global int* interestingBlockMarks,

                                global int* activeBlocks, global int* activeBlockIndices, volatile global int* numOfActiveBlocks,

                                int mark, int numOfActiveParticles, int numOfBlocksInX, int numOfBlocksInY, int numOfBlocksInZ, double globalMinX, double globalMinY, double globalMinZ, double blockSize, double epsilon) {
  int globalID = get_global_id(0);

  if (globalID < numOfActiveParticles) {
    int particleID = activeParticles[hook(0, globalID)];
    double posX = placesOfInterest[hook(2, particleID * 3)];
    double posY = placesOfInterest[hook(2, particleID * 3 + 1)];
    double posZ = placesOfInterest[hook(2, particleID * 3 + 2)];

    int x = (int)((posX - globalMinX) / blockSize);
    int y = (int)((posY - globalMinY) / blockSize);
    int z = (int)((posZ - globalMinZ) / blockSize);

    int blockID = GetBlockID(x, y, z, numOfBlocksInY, numOfBlocksInZ);
    int tetID = exitCells[hook(1, particleID)];

    int localTetID = GetLocalTetID(blockID, tetID, startOffsetsInLocalIDMap, blocksOfTets, localIDsOfTets);

    if (localTetID == -1) {
      int dx[3], dy[3], dz[3];
      int lx = 1, ly = 1, lz = 1;
      dx[hook(23, 0)] = dy[hook(24, 0)] = dz[hook(25, 0)] = 0;

      double xLower = globalMinX + x * blockSize;
      double yLower = globalMinY + y * blockSize;
      double zLower = globalMinZ + z * blockSize;

      if (!Sign(xLower - posX, 2 * epsilon))
        dx[hook(23, lx++)] = -1;
      if (!Sign(yLower - posY, 2 * epsilon))
        dy[hook(24, ly++)] = -1;
      if (!Sign(zLower - posZ, 2 * epsilon))
        dz[hook(25, lz++)] = -1;

      if (!Sign(xLower + blockSize - posX, 2 * epsilon))
        dx[hook(23, lx++)] = 1;
      if (!Sign(yLower + blockSize - posY, 2 * epsilon))
        dy[hook(24, ly++)] = 1;
      if (!Sign(zLower + blockSize - posZ, 2 * epsilon))
        dz[hook(25, lz++)] = 1;

      for (int i = 0; localTetID == -1 && i < lx; i++)
        for (int j = 0; localTetID == -1 && j < ly; j++)
          for (int k = 0; k < lz; k++) {
            if (i + j + k == 0)
              continue;
            int _x = x + dx[hook(23, i)];
            int _y = y + dy[hook(24, j)];
            int _z = z + dz[hook(25, k)];

            if (_x < 0 || _y < 0 || _z < 0 || _x >= numOfBlocksInX || _y >= numOfBlocksInY || _z >= numOfBlocksInZ)
              continue;

            blockID = GetBlockID(_x, _y, _z, numOfBlocksInY, numOfBlocksInZ);
            localTetID = GetLocalTetID(blockID, tetID, startOffsetsInLocalIDMap, blocksOfTets, localIDsOfTets);

            if (localTetID != -1)
              break;
          }

      if (localTetID == -1)
        while (1)
          ;
    }

    localTetIDs[hook(3, particleID)] = localTetID;

    int interestingBlockID = interestingBlockMap[hook(5, blockID)];
    blockLocations[hook(4, particleID)] = interestingBlockID;

    int oldMark = atomic_add(interestingBlockMarks + interestingBlockID, 0);

    int index;

    if (oldMark < mark) {
      int delta = mark - oldMark;
      int newMark = atomic_add(interestingBlockMarks + interestingBlockID, delta);

      if (newMark >= mark)
        atomic_add(interestingBlockMarks + interestingBlockID, -delta);
      else {
        index = atomic_add(numOfActiveBlocks, 1);
        activeBlocks[hook(10, index)] = interestingBlockID;
        activeBlockIndices[hook(11, interestingBlockID)] = index;
      }
    }
  }
}