//{"a":36,"activeBlockList":17,"blockOfGroups":18,"blockedActiveParticleIDList":28,"blockedGlobalCellIDs":15,"blockedGlobalPointIDs":16,"blockedLocalConnectivities":13,"blockedLocalLinks":14,"canFitInSharedMemory":12,"cellLocations":29,"connectivities":41,"coordinates":40,"currK":58,"currK1":48,"currK2":49,"currK3":50,"currK4":59,"currLastPosition":47,"endTime":33,"endVelocities":46,"endVelocitiesForBig":11,"epsilon":35,"exitCells":30,"float4":43,"gConnectivities":55,"gEndVelocities":57,"gStartVelocities":56,"globalEndVelocities":2,"globalStartVelocities":1,"globalTetrahedralConnectivities":3,"globalTetrahedralLinks":4,"globalVertexPositions":0,"k1":22,"k2":23,"k3":24,"lastPosition":21,"links":44,"offsetInBlocks":19,"pastTimes":25,"placeOfInterest":51,"placesOfInterest":26,"sharedMemory":31,"stage":20,"startOffsetInCell":5,"startOffsetInCellForBig":7,"startOffsetInParticle":27,"startOffsetInPoint":6,"startOffsetInPointForBig":8,"startTime":32,"startVelocities":45,"startVelocitiesForBig":10,"tetX":37,"tetY":38,"tetZ":39,"timeStep":34,"vecX":52,"vecY":53,"vecZ":54,"vertexPositions":42,"vertexPositionsForBig":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline double DeterminantThree(double* a) {
  return a[hook(36, 0)] * a[hook(36, 4)] * a[hook(36, 8)] + a[hook(36, 1)] * a[hook(36, 5)] * a[hook(36, 6)] + a[hook(36, 2)] * a[hook(36, 3)] * a[hook(36, 7)] - a[hook(36, 0)] * a[hook(36, 5)] * a[hook(36, 7)] - a[hook(36, 1)] * a[hook(36, 3)] * a[hook(36, 8)] - a[hook(36, 2)] * a[hook(36, 4)] * a[hook(36, 6)];
}

inline void CalculateNaturalCoordinates(double X, double Y, double Z, double* tetX, double* tetY, double* tetZ, double* coordinates) {
  X -= tetX[hook(37, 0)];
  Y -= tetY[hook(38, 0)];
  Z -= tetZ[hook(39, 0)];

  double det[9] = {tetX[hook(37, 1)] - tetX[hook(37, 0)], tetY[hook(38, 1)] - tetY[hook(38, 0)], tetZ[hook(39, 1)] - tetZ[hook(39, 0)], tetX[hook(37, 2)] - tetX[hook(37, 0)], tetY[hook(38, 2)] - tetY[hook(38, 0)], tetZ[hook(39, 2)] - tetZ[hook(39, 0)], tetX[hook(37, 3)] - tetX[hook(37, 0)], tetY[hook(38, 3)] - tetY[hook(38, 0)], tetZ[hook(39, 3)] - tetZ[hook(39, 0)]};

  double V = 1 / DeterminantThree(det);

  double z41 = tetZ[hook(39, 3)] - tetZ[hook(39, 0)];
  double y34 = tetY[hook(38, 2)] - tetY[hook(38, 3)];
  double z34 = tetZ[hook(39, 2)] - tetZ[hook(39, 3)];
  double y41 = tetY[hook(38, 3)] - tetY[hook(38, 0)];
  double a11 = (z41 * y34 - z34 * y41) * V;

  double x41 = tetX[hook(37, 3)] - tetX[hook(37, 0)];
  double x34 = tetX[hook(37, 2)] - tetX[hook(37, 3)];
  double a12 = (x41 * z34 - x34 * z41) * V;

  double a13 = (y41 * x34 - y34 * x41) * V;

  coordinates[hook(40, 1)] = a11 * X + a12 * Y + a13 * Z;

  double y12 = tetY[hook(38, 0)] - tetY[hook(38, 1)];
  double z12 = tetZ[hook(39, 0)] - tetZ[hook(39, 1)];
  double a21 = (z41 * y12 - z12 * y41) * V;

  double x12 = tetX[hook(37, 0)] - tetX[hook(37, 1)];
  double a22 = (x41 * z12 - x12 * z41) * V;

  double a23 = (y41 * x12 - y12 * x41) * V;

  coordinates[hook(40, 2)] = a21 * X + a22 * Y + a23 * Z;

  double z23 = tetZ[hook(39, 1)] - tetZ[hook(39, 2)];
  double y23 = tetY[hook(38, 1)] - tetY[hook(38, 2)];
  double a31 = (z23 * y12 - z12 * y23) * V;

  double x23 = tetX[hook(37, 1)] - tetX[hook(37, 2)];
  double a32 = (x23 * z12 - x12 * z23) * V;

  double a33 = (y23 * x12 - y12 * x23) * V;

  coordinates[hook(40, 3)] = a31 * X + a32 * Y + a33 * Z;

  coordinates[hook(40, 0)] = 1 - coordinates[hook(40, 1)] - coordinates[hook(40, 2)] - coordinates[hook(40, 3)];
}

inline int globalFindCell(double* float4, global int* connectivities, global int* links, global double* vertexPositions, double epsilon, int guess, double* coordinates) {
  double tetX[4], tetY[4], tetZ[4];

  while (true) {
    for (int i = 0; i < 4; i++) {
      int pointID = connectivities[hook(41, (guess << 2) | i)];

      tetX[hook(37, i)] = vertexPositions[hook(42, pointID * 3)];
      tetY[hook(38, i)] = vertexPositions[hook(42, pointID * 3 + 1)];
      tetZ[hook(39, i)] = vertexPositions[hook(42, pointID * 3 + 2)];
    }

    CalculateNaturalCoordinates(float4[hook(43, 0)], float4[hook(43, 1)], float4[hook(43, 2)], tetX, tetY, tetZ, coordinates);

    int index = 0;

    for (int i = 1; i < 4; i++)
      if (coordinates[hook(40, i)] < coordinates[hook(40, index)])
        index = i;
    if (coordinates[hook(40, index)] >= -epsilon)
      break;

    guess = links[hook(44, (guess << 2) | index)];

    if (guess == -1)
      break;
  }

  return guess;
}

inline int localFindCell(double* float4, local int* connectivities, local int* links, local double* vertexPositions, double epsilon, int guess, double* coordinates) {
  double tetX[4], tetY[4], tetZ[4];

  while (true) {
    for (int i = 0; i < 4; i++) {
      int pointID = connectivities[hook(41, (guess << 2) | i)];
      tetX[hook(37, i)] = vertexPositions[hook(42, pointID * 3)];
      tetY[hook(38, i)] = vertexPositions[hook(42, pointID * 3 + 1)];
      tetZ[hook(39, i)] = vertexPositions[hook(42, pointID * 3 + 2)];
    }

    CalculateNaturalCoordinates(float4[hook(43, 0)], float4[hook(43, 1)], float4[hook(43, 2)], tetX, tetY, tetZ, coordinates);

    int index = 0;
    for (int i = 1; i < 4; i++)
      if (coordinates[hook(40, i)] < coordinates[hook(40, index)])
        index = i;
    if (coordinates[hook(40, index)] >= -epsilon)
      break;

    guess = links[hook(44, (guess << 2) | index)];

    if (guess == -1)
      break;
  }

  return guess;
}

kernel void BlockedTracing(global double* globalVertexPositions, global double* globalStartVelocities, global double* globalEndVelocities, global int* globalTetrahedralConnectivities, global int* globalTetrahedralLinks,

                           global int* startOffsetInCell, global int* startOffsetInPoint,

                           global int* startOffsetInCellForBig, global int* startOffsetInPointForBig, global double* vertexPositionsForBig, global double* startVelocitiesForBig, global double* endVelocitiesForBig,

                           global bool* canFitInSharedMemory,

                           global int* blockedLocalConnectivities, global int* blockedLocalLinks, global int* blockedGlobalCellIDs, global int* blockedGlobalPointIDs,

                           global int* activeBlockList,

                           global int* blockOfGroups, global int* offsetInBlocks,

                           global int* stage, global double* lastPosition, global double* k1, global double* k2, global double* k3, global double* pastTimes,

                           global double* placesOfInterest,

                           global int* startOffsetInParticle, global int* blockedActiveParticleIDList, global int* cellLocations,

                           global int* exitCells,

                           local void* sharedMemory,

                           double startTime, double endTime, double timeStep, double epsilon) {
  int groupID = get_group_id(0);

  int numOfThreads = get_local_size(0);

  int localID = get_local_id(0);

  int activeBlockID = blockOfGroups[hook(18, groupID)];

  int interestingBlockID = activeBlockList[hook(17, activeBlockID)];

  local double* vertexPositions;
  local double* startVelocities;
  local double* endVelocities;
  local int* connectivities;
  local int* links;

  global double* gVertexPositions;
  global double* gStartVelocities;
  global double* gEndVelocities;
  global int* gConnectivities;
  global int* gLinks;

  bool canFit = canFitInSharedMemory[hook(12, interestingBlockID)];

  int startCell = startOffsetInCell[hook(5, interestingBlockID)];
  int startPoint = startOffsetInPoint[hook(6, interestingBlockID)];

  int numOfCells = startOffsetInCell[hook(5, interestingBlockID + 1)] - startCell;
  int numOfPoints = startOffsetInPoint[hook(6, interestingBlockID + 1)] - startPoint;

  int startCellForBig = startOffsetInCellForBig[hook(7, interestingBlockID)];
  int startPointForBig = startOffsetInPointForBig[hook(8, interestingBlockID)];

  if (canFit) {
    vertexPositions = (local double*)sharedMemory;
    startVelocities = vertexPositions + numOfPoints * 3;
    endVelocities = startVelocities + numOfPoints * 3;

    connectivities = (local int*)(endVelocities + numOfPoints * 3);
    links = connectivities + (numOfCells << 2);
  } else {
    gVertexPositions = vertexPositionsForBig + startPointForBig * 3;
    gStartVelocities = startVelocitiesForBig + startPointForBig * 3;
    gEndVelocities = endVelocitiesForBig + startPointForBig * 3;

    gConnectivities = blockedLocalConnectivities + (startCell << 2);
    gLinks = blockedLocalLinks + (startCell << 2);
  }

  for (int i = localID; i < numOfPoints * 3; i += numOfThreads) {
    int localPointID = i / 3;
    int dimensionID = i % 3;
    int globalPointID = blockedGlobalPointIDs[hook(16, startPoint + localPointID)];

    if (canFit) {
      vertexPositions[hook(42, i)] = globalVertexPositions[hook(0, globalPointID * 3 + dimensionID)];
      startVelocities[hook(45, i)] = globalStartVelocities[hook(1, globalPointID * 3 + dimensionID)];
      endVelocities[hook(46, i)] = globalEndVelocities[hook(2, globalPointID * 3 + dimensionID)];
    }
  }

  if (canFit)
    for (int i = localID; i < (numOfCells << 2); i += numOfThreads) {
      connectivities[hook(41, i)] = *(blockedLocalConnectivities + (startCell << 2) + i);
      links[hook(44, i)] = *(blockedLocalLinks + (startCell << 2) + i);
    }

  if (canFit)
    barrier(0x01);
  else
    barrier(0x02);

  int numOfActiveParticles = startOffsetInParticle[hook(27, activeBlockID + 1)] - startOffsetInParticle[hook(27, activeBlockID)];

  int arrayIdx = offsetInBlocks[hook(19, groupID)] * numOfThreads + localID;

  if (arrayIdx < numOfActiveParticles) {
    arrayIdx += startOffsetInParticle[hook(27, activeBlockID)];
    int activeParticleID = blockedActiveParticleIDList[hook(28, arrayIdx)];

    int currStage = stage[hook(20, activeParticleID)];
    int currCell = cellLocations[hook(29, activeParticleID)];

    double currTime = pastTimes[hook(25, activeParticleID)];

    double currLastPosition[3];
    currLastPosition[hook(47, 0)] = lastPosition[hook(21, activeParticleID * 3)];
    currLastPosition[hook(47, 1)] = lastPosition[hook(21, activeParticleID * 3 + 1)];
    currLastPosition[hook(47, 2)] = lastPosition[hook(21, activeParticleID * 3 + 2)];
    double currK1[3], currK2[3], currK3[3], currK4[3];
    if (currStage > 0) {
      currK1[hook(48, 0)] = k1[hook(22, activeParticleID * 3)];
      currK1[hook(48, 1)] = k1[hook(22, activeParticleID * 3 + 1)];
      currK1[hook(48, 2)] = k1[hook(22, activeParticleID * 3 + 2)];
    }
    if (currStage > 1) {
      currK2[hook(49, 0)] = k2[hook(23, activeParticleID * 3)];
      currK2[hook(49, 1)] = k2[hook(23, activeParticleID * 3 + 1)];
      currK2[hook(49, 2)] = k2[hook(23, activeParticleID * 3 + 2)];
    }
    if (currStage > 2) {
      currK3[hook(50, 0)] = k3[hook(24, activeParticleID * 3)];
      currK3[hook(50, 1)] = k3[hook(24, activeParticleID * 3 + 1)];
      currK3[hook(50, 2)] = k3[hook(24, activeParticleID * 3 + 2)];
    }

    while (true) {
      double placeOfInterest[3];
      placeOfInterest[hook(51, 0)] = currLastPosition[hook(47, 0)];
      placeOfInterest[hook(51, 1)] = currLastPosition[hook(47, 1)];
      placeOfInterest[hook(51, 2)] = currLastPosition[hook(47, 2)];
      switch (currStage) {
        case 1: {
          placeOfInterest[hook(51, 0)] += 0.5 * currK1[hook(48, 0)];
          placeOfInterest[hook(51, 1)] += 0.5 * currK1[hook(48, 1)];
          placeOfInterest[hook(51, 2)] += 0.5 * currK1[hook(48, 2)];
        } break;
        case 2: {
          placeOfInterest[hook(51, 0)] += 0.5 * currK2[hook(49, 0)];
          placeOfInterest[hook(51, 1)] += 0.5 * currK2[hook(49, 1)];
          placeOfInterest[hook(51, 2)] += 0.5 * currK2[hook(49, 2)];
        } break;
        case 3: {
          placeOfInterest[hook(51, 0)] += currK3[hook(50, 0)];
          placeOfInterest[hook(51, 1)] += currK3[hook(50, 1)];
          placeOfInterest[hook(51, 2)] += currK3[hook(50, 2)];
        } break;
      }

      double coordinates[4];

      int nextCell;

      if (canFit)
        nextCell = localFindCell(placeOfInterest, connectivities, links, vertexPositions, epsilon, currCell, coordinates);
      else
        nextCell = globalFindCell(placeOfInterest, gConnectivities, gLinks, gVertexPositions, epsilon, currCell, coordinates);

      if (nextCell == -1 || currTime >= endTime) {
        int globalCellID = blockedGlobalCellIDs[hook(15, startCell + currCell)];
        int nextGlobalCell;

        if (nextCell != -1)
          nextGlobalCell = blockedGlobalCellIDs[hook(15, startCell + nextCell)];
        else
          nextGlobalCell = globalFindCell(placeOfInterest, globalTetrahedralConnectivities, globalTetrahedralLinks, globalVertexPositions, epsilon, globalCellID, coordinates);

        if (currTime >= endTime && nextGlobalCell != -1)
          nextGlobalCell = -2 - nextGlobalCell;

        pastTimes[hook(25, activeParticleID)] = currTime;

        stage[hook(20, activeParticleID)] = currStage;

        lastPosition[hook(21, activeParticleID * 3)] = currLastPosition[hook(47, 0)];
        lastPosition[hook(21, activeParticleID * 3 + 1)] = currLastPosition[hook(47, 1)];
        lastPosition[hook(21, activeParticleID * 3 + 2)] = currLastPosition[hook(47, 2)];

        placesOfInterest[hook(26, activeParticleID * 3)] = placeOfInterest[hook(51, 0)];
        placesOfInterest[hook(26, activeParticleID * 3 + 1)] = placeOfInterest[hook(51, 1)];
        placesOfInterest[hook(26, activeParticleID * 3 + 2)] = placeOfInterest[hook(51, 2)];

        exitCells[hook(30, activeParticleID)] = nextGlobalCell;

        if (currStage > 0) {
          k1[hook(22, activeParticleID * 3)] = currK1[hook(48, 0)];
          k1[hook(22, activeParticleID * 3 + 1)] = currK1[hook(48, 1)];
          k1[hook(22, activeParticleID * 3 + 2)] = currK1[hook(48, 2)];
        }
        if (currStage > 1) {
          k2[hook(23, activeParticleID * 3)] = currK2[hook(49, 0)];
          k2[hook(23, activeParticleID * 3 + 1)] = currK2[hook(49, 1)];
          k2[hook(23, activeParticleID * 3 + 2)] = currK2[hook(49, 2)];
        }
        if (currStage > 2) {
          k3[hook(24, activeParticleID * 3)] = currK3[hook(50, 0)];
          k3[hook(24, activeParticleID * 3 + 1)] = currK3[hook(50, 1)];
          k3[hook(24, activeParticleID * 3 + 2)] = currK3[hook(50, 2)];
        }
        break;
      }

      currCell = nextCell;

      double alpha = (endTime - currTime) / (endTime - startTime);
      double beta = 1 - alpha;

      double vecX[4], vecY[4], vecZ[4];

      for (int i = 0; i < 4; i++)
        if (canFit) {
          int pointID = connectivities[hook(41, (nextCell << 2) | i)];
          vecX[hook(52, i)] = startVelocities[hook(45, pointID * 3)] * alpha + endVelocities[hook(46, pointID * 3)] * beta;
          vecY[hook(53, i)] = startVelocities[hook(45, pointID * 3 + 1)] * alpha + endVelocities[hook(46, pointID * 3 + 1)] * beta;
          vecZ[hook(54, i)] = startVelocities[hook(45, pointID * 3 + 2)] * alpha + endVelocities[hook(46, pointID * 3 + 2)] * beta;
        } else {
          int pointID = gConnectivities[hook(55, (nextCell << 2) | i)];
          vecX[hook(52, i)] = gStartVelocities[hook(56, pointID * 3)] * alpha + gEndVelocities[hook(57, pointID * 3)] * beta;
          vecY[hook(53, i)] = gStartVelocities[hook(56, pointID * 3 + 1)] * alpha + gEndVelocities[hook(57, pointID * 3 + 1)] * beta;
          vecZ[hook(54, i)] = gStartVelocities[hook(56, pointID * 3 + 2)] * alpha + gEndVelocities[hook(57, pointID * 3 + 2)] * beta;
        }

      double* currK;
      switch (currStage) {
        case 0:
          currK = currK1;
          break;
        case 1:
          currK = currK2;
          break;
        case 2:
          currK = currK3;
          break;
        case 3:
          currK = currK4;
          break;
      }

      currK[hook(58, 0)] = currK[hook(58, 1)] = currK[hook(58, 2)] = 0;

      for (int i = 0; i < 4; i++) {
        currK[hook(58, 0)] += vecX[hook(52, i)] * coordinates[hook(40, i)];
        currK[hook(58, 1)] += vecY[hook(53, i)] * coordinates[hook(40, i)];
        currK[hook(58, 2)] += vecZ[hook(54, i)] * coordinates[hook(40, i)];
      }

      currK[hook(58, 0)] *= timeStep;
      currK[hook(58, 1)] *= timeStep;
      currK[hook(58, 2)] *= timeStep;

      if (currStage == 3) {
        currTime += timeStep;

        for (int i = 0; i < 3; i++)
          currLastPosition[hook(47, i)] += (currK1[hook(48, i)] + 2 * currK2[hook(49, i)] + 2 * currK3[hook(50, i)] + currK4[hook(59, i)]) / 6;

        currStage = 0;
      } else
        currStage++;
    }
  }
}