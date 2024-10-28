//{"a":38,"activeBlockList":17,"blockedActiveParticleIDList":25,"blockedCellLocationList":26,"blockedGlobalCellIDs":15,"blockedGlobalPointIDs":16,"blockedLocalConnectivities":13,"blockedLocalLinks":14,"canFitInSharedMemory":12,"connectivities":43,"coordinates":42,"currK":60,"currK1":50,"currK2":51,"currK3":52,"currK4":61,"currLastPosition":49,"endTime":29,"endVelocities":48,"endVelocitiesForBig":11,"epsilon":31,"float4":45,"gConnectivities":57,"gEndVelocities":59,"gStartVelocities":58,"globalEndVelocities":2,"globalStartVelocities":1,"globalTetrahedralConnectivities":3,"globalTetrahedralLinks":4,"globalVertexPositions":0,"k1":20,"k2":21,"k3":22,"lastPosition":19,"links":46,"pastTimes":23,"placeOfInterest":53,"sharedMemory":27,"squeezedExitCells":37,"squeezedK1":34,"squeezedK2":35,"squeezedK3":36,"squeezedLastPosition":33,"squeezedStage":32,"stage":18,"startOffsetInCell":5,"startOffsetInCellForBig":7,"startOffsetInParticle":24,"startOffsetInPoint":6,"startOffsetInPointForBig":8,"startTime":28,"startVelocities":47,"startVelocitiesForBig":10,"tetX":39,"tetY":40,"tetZ":41,"timeStep":30,"vecX":54,"vecY":55,"vecZ":56,"vertexPositions":44,"vertexPositionsForBig":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline double DeterminantThree(double* a) {
  return a[hook(38, 0)] * a[hook(38, 4)] * a[hook(38, 8)] + a[hook(38, 1)] * a[hook(38, 5)] * a[hook(38, 6)] + a[hook(38, 2)] * a[hook(38, 3)] * a[hook(38, 7)] - a[hook(38, 0)] * a[hook(38, 5)] * a[hook(38, 7)] - a[hook(38, 1)] * a[hook(38, 3)] * a[hook(38, 8)] - a[hook(38, 2)] * a[hook(38, 4)] * a[hook(38, 6)];
}

inline void CalculateNaturalCoordinates(double X, double Y, double Z, double* tetX, double* tetY, double* tetZ, double* coordinates) {
  X -= tetX[hook(39, 0)];
  Y -= tetY[hook(40, 0)];
  Z -= tetZ[hook(41, 0)];

  double det[9] = {tetX[hook(39, 1)] - tetX[hook(39, 0)], tetY[hook(40, 1)] - tetY[hook(40, 0)], tetZ[hook(41, 1)] - tetZ[hook(41, 0)], tetX[hook(39, 2)] - tetX[hook(39, 0)], tetY[hook(40, 2)] - tetY[hook(40, 0)], tetZ[hook(41, 2)] - tetZ[hook(41, 0)], tetX[hook(39, 3)] - tetX[hook(39, 0)], tetY[hook(40, 3)] - tetY[hook(40, 0)], tetZ[hook(41, 3)] - tetZ[hook(41, 0)]};

  double V = 1 / DeterminantThree(det);

  double z41 = tetZ[hook(41, 3)] - tetZ[hook(41, 0)];
  double y34 = tetY[hook(40, 2)] - tetY[hook(40, 3)];
  double z34 = tetZ[hook(41, 2)] - tetZ[hook(41, 3)];
  double y41 = tetY[hook(40, 3)] - tetY[hook(40, 0)];
  double a11 = (z41 * y34 - z34 * y41) * V;

  double x41 = tetX[hook(39, 3)] - tetX[hook(39, 0)];
  double x34 = tetX[hook(39, 2)] - tetX[hook(39, 3)];
  double a12 = (x41 * z34 - x34 * z41) * V;

  double a13 = (y41 * x34 - y34 * x41) * V;

  coordinates[hook(42, 1)] = a11 * X + a12 * Y + a13 * Z;

  double y12 = tetY[hook(40, 0)] - tetY[hook(40, 1)];
  double z12 = tetZ[hook(41, 0)] - tetZ[hook(41, 1)];
  double a21 = (z41 * y12 - z12 * y41) * V;

  double x12 = tetX[hook(39, 0)] - tetX[hook(39, 1)];
  double a22 = (x41 * z12 - x12 * z41) * V;

  double a23 = (y41 * x12 - y12 * x41) * V;

  coordinates[hook(42, 2)] = a21 * X + a22 * Y + a23 * Z;

  double z23 = tetZ[hook(41, 1)] - tetZ[hook(41, 2)];
  double y23 = tetY[hook(40, 1)] - tetY[hook(40, 2)];
  double a31 = (z23 * y12 - z12 * y23) * V;

  double x23 = tetX[hook(39, 1)] - tetX[hook(39, 2)];
  double a32 = (x23 * z12 - x12 * z23) * V;

  double a33 = (y23 * x12 - y12 * x23) * V;

  coordinates[hook(42, 3)] = a31 * X + a32 * Y + a33 * Z;

  coordinates[hook(42, 0)] = 1 - coordinates[hook(42, 1)] - coordinates[hook(42, 2)] - coordinates[hook(42, 3)];
}

inline int gFindCell(double* float4, global int* connectivities, global int* links, global double* vertexPositions, double epsilon, int guess, double* coordinates) {
  double tetX[4], tetY[4], tetZ[4];

  while (true) {
    for (int i = 0; i < 4; i++) {
      int pointID = connectivities[hook(43, (guess << 2) | i)];

      tetX[hook(39, i)] = vertexPositions[hook(44, pointID * 3)];
      tetY[hook(40, i)] = vertexPositions[hook(44, pointID * 3 + 1)];
      tetZ[hook(41, i)] = vertexPositions[hook(44, pointID * 3 + 2)];
    }

    CalculateNaturalCoordinates(float4[hook(45, 0)], float4[hook(45, 1)], float4[hook(45, 2)], tetX, tetY, tetZ, coordinates);

    int index = 0;
    for (int i = 1; i < 4; i++)
      if (coordinates[hook(42, i)] < coordinates[hook(42, index)])
        index = i;
    if (coordinates[hook(42, index)] >= -epsilon)
      break;

    guess = links[hook(46, (guess << 2) | index)];

    if (guess == -1)
      break;
  }

  return guess;
}

inline int FindCell(double* float4, local int* connectivities, local int* links, local double* vertexPositions, double epsilon, int guess, double* coordinates) {
  double tetX[4], tetY[4], tetZ[4];
  while (true) {
    for (int i = 0; i < 4; i++) {
      int pointID = connectivities[hook(43, (guess << 2) | i)];
      tetX[hook(39, i)] = vertexPositions[hook(44, pointID * 3)];
      tetY[hook(40, i)] = vertexPositions[hook(44, pointID * 3 + 1)];
      tetZ[hook(41, i)] = vertexPositions[hook(44, pointID * 3 + 2)];
    }
    CalculateNaturalCoordinates(float4[hook(45, 0)], float4[hook(45, 1)], float4[hook(45, 2)], tetX, tetY, tetZ, coordinates);
    int index = 0;
    for (int i = 1; i < 4; i++)
      if (coordinates[hook(42, i)] < coordinates[hook(42, index)])
        index = i;
    if (coordinates[hook(42, index)] >= -epsilon)
      break;
    guess = links[hook(46, (guess << 2) | index)];
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

                           global int* stage, global double* lastPosition, global double* k1, global double* k2, global double* k3, global double* pastTimes, global int* startOffsetInParticle, global int* blockedActiveParticleIDList, global int* blockedCellLocationList,

                           local void* sharedMemory,

                           double startTime, double endTime, double timeStep, double epsilon,

                           global int* squeezedStage, global double* squeezedLastPosition, global double* squeezedK1, global double* squeezedK2, global double* squeezedK3, global int* squeezedExitCells) {
  int activeBlockID = get_group_id(0);

  int numOfThreads = get_local_size(0);

  int localID = get_local_id(0);

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
      vertexPositions[hook(44, i)] = globalVertexPositions[hook(0, globalPointID * 3 + dimensionID)];
      startVelocities[hook(47, i)] = globalStartVelocities[hook(1, globalPointID * 3 + dimensionID)];
      endVelocities[hook(48, i)] = globalEndVelocities[hook(2, globalPointID * 3 + dimensionID)];
    } else {
    }
  }

  if (canFit)
    for (int i = localID; i < (numOfCells << 2); i += numOfThreads) {
      connectivities[hook(43, i)] = *(blockedLocalConnectivities + (startCell << 2) + i);
      links[hook(46, i)] = *(blockedLocalLinks + (startCell << 2) + i);
    }

  if (canFit)
    barrier(0x01);
  else
    barrier(0x02);

  int numOfActiveParticles = startOffsetInParticle[hook(24, activeBlockID + 1)] - startOffsetInParticle[hook(24, activeBlockID)];

  for (int idx = localID; idx < numOfActiveParticles; idx += numOfThreads) {
    int arrayIdx = startOffsetInParticle[hook(24, activeBlockID)] + idx;
    int activeParticleID = blockedActiveParticleIDList[hook(25, arrayIdx)];

    int currStage = stage[hook(18, activeParticleID)];
    int currCell = blockedCellLocationList[hook(26, startOffsetInParticle[ahook(24, activeBlockID) + idx)];

    double currTime = pastTimes[hook(23, activeParticleID)];

    double currLastPosition[3];
    currLastPosition[hook(49, 0)] = lastPosition[hook(19, activeParticleID * 3)];
    currLastPosition[hook(49, 1)] = lastPosition[hook(19, activeParticleID * 3 + 1)];
    currLastPosition[hook(49, 2)] = lastPosition[hook(19, activeParticleID * 3 + 2)];
    double currK1[3], currK2[3], currK3[3], currK4[3];
    if (currStage > 0) {
      currK1[hook(50, 0)] = k1[hook(20, activeParticleID * 3)];
      currK1[hook(50, 1)] = k1[hook(20, activeParticleID * 3 + 1)];
      currK1[hook(50, 2)] = k1[hook(20, activeParticleID * 3 + 2)];
    }
    if (currStage > 1) {
      currK2[hook(51, 0)] = k2[hook(21, activeParticleID * 3)];
      currK2[hook(51, 1)] = k2[hook(21, activeParticleID * 3 + 1)];
      currK2[hook(51, 2)] = k2[hook(21, activeParticleID * 3 + 2)];
    }
    if (currStage > 2) {
      currK3[hook(52, 0)] = k3[hook(22, activeParticleID * 3)];
      currK3[hook(52, 1)] = k3[hook(22, activeParticleID * 3 + 1)];
      currK3[hook(52, 2)] = k3[hook(22, activeParticleID * 3 + 2)];
    }

    while (true) {
      double placeOfInterest[3];
      placeOfInterest[hook(53, 0)] = currLastPosition[hook(49, 0)];
      placeOfInterest[hook(53, 1)] = currLastPosition[hook(49, 1)];
      placeOfInterest[hook(53, 2)] = currLastPosition[hook(49, 2)];
      switch (currStage) {
        case 1: {
          placeOfInterest[hook(53, 0)] += 0.5 * currK1[hook(50, 0)];
          placeOfInterest[hook(53, 1)] += 0.5 * currK1[hook(50, 1)];
          placeOfInterest[hook(53, 2)] += 0.5 * currK1[hook(50, 2)];
        } break;
        case 2: {
          placeOfInterest[hook(53, 0)] += 0.5 * currK2[hook(51, 0)];
          placeOfInterest[hook(53, 1)] += 0.5 * currK2[hook(51, 1)];
          placeOfInterest[hook(53, 2)] += 0.5 * currK2[hook(51, 2)];
        } break;
        case 3: {
          placeOfInterest[hook(53, 0)] += currK3[hook(52, 0)];
          placeOfInterest[hook(53, 1)] += currK3[hook(52, 1)];
          placeOfInterest[hook(53, 2)] += currK3[hook(52, 2)];
        } break;
      }

      double coordinates[4];

      int nextCell;

      if (canFit)
        nextCell = FindCell(placeOfInterest, connectivities, links, vertexPositions, epsilon, currCell, coordinates);
      else
        nextCell = gFindCell(placeOfInterest, gConnectivities, gLinks, gVertexPositions, epsilon, currCell, coordinates);

      if (nextCell == -1 || currTime >= endTime) {
        int globalCellID = blockedGlobalCellIDs[hook(15, startCell + currCell)];
        int nextGlobalCell;

        if (nextCell != -1)
          nextGlobalCell = blockedGlobalCellIDs[hook(15, startCell + nextCell)];
        else
          nextGlobalCell = gFindCell(placeOfInterest, globalTetrahedralConnectivities, globalTetrahedralLinks, globalVertexPositions, epsilon, globalCellID, coordinates);

        if (currTime >= endTime && nextGlobalCell != -1)
          nextGlobalCell = -2 - nextGlobalCell;

        pastTimes[hook(23, activeParticleID)] = currTime;

        stage[hook(18, activeParticleID)] = currStage;

        lastPosition[hook(19, activeParticleID * 3)] = currLastPosition[hook(49, 0)];
        lastPosition[hook(19, activeParticleID * 3 + 1)] = currLastPosition[hook(49, 1)];
        lastPosition[hook(19, activeParticleID * 3 + 2)] = currLastPosition[hook(49, 2)];

        if (currStage > 0) {
          k1[hook(20, activeParticleID * 3)] = currK1[hook(50, 0)];
          k1[hook(20, activeParticleID * 3 + 1)] = currK1[hook(50, 1)];
          k1[hook(20, activeParticleID * 3 + 2)] = currK1[hook(50, 2)];
        }
        if (currStage > 1) {
          k2[hook(21, activeParticleID * 3)] = currK2[hook(51, 0)];
          k2[hook(21, activeParticleID * 3 + 1)] = currK2[hook(51, 1)];
          k2[hook(21, activeParticleID * 3 + 2)] = currK2[hook(51, 2)];
        }
        if (currStage > 2) {
          k3[hook(22, activeParticleID * 3)] = currK3[hook(52, 0)];
          k3[hook(22, activeParticleID * 3 + 1)] = currK3[hook(52, 1)];
          k3[hook(22, activeParticleID * 3 + 2)] = currK3[hook(52, 2)];
        }

        squeezedStage[hook(32, arrayIdx)] = currStage;
        squeezedExitCells[hook(37, arrayIdx)] = nextGlobalCell;

        squeezedLastPosition[hook(33, arrayIdx * 3)] = currLastPosition[hook(49, 0)];
        squeezedLastPosition[hook(33, arrayIdx * 3 + 1)] = currLastPosition[hook(49, 1)];
        squeezedLastPosition[hook(33, arrayIdx * 3 + 2)] = currLastPosition[hook(49, 2)];

        if (currStage > 0) {
          squeezedK1[hook(34, arrayIdx * 3)] = currK1[hook(50, 0)];
          squeezedK1[hook(34, arrayIdx * 3 + 1)] = currK1[hook(50, 1)];
          squeezedK1[hook(34, arrayIdx * 3 + 2)] = currK1[hook(50, 2)];
        }
        if (currStage > 1) {
          squeezedK2[hook(35, arrayIdx * 3)] = currK2[hook(51, 0)];
          squeezedK2[hook(35, arrayIdx * 3 + 1)] = currK2[hook(51, 1)];
          squeezedK2[hook(35, arrayIdx * 3 + 2)] = currK2[hook(51, 2)];
        }
        if (currStage > 2) {
          squeezedK3[hook(36, arrayIdx * 3)] = currK3[hook(52, 0)];
          squeezedK3[hook(36, arrayIdx * 3 + 1)] = currK3[hook(52, 1)];
          squeezedK3[hook(36, arrayIdx * 3 + 2)] = currK3[hook(52, 2)];
        }

        break;
      }

      currCell = nextCell;

      double alpha = (endTime - currTime) / (endTime - startTime);
      double beta = 1 - alpha;

      double vecX[4], vecY[4], vecZ[4];

      for (int i = 0; i < 4; i++)
        if (canFit) {
          int pointID = connectivities[hook(43, (nextCell << 2) | i)];
          vecX[hook(54, i)] = startVelocities[hook(47, pointID * 3)] * alpha + endVelocities[hook(48, pointID * 3)] * beta;
          vecY[hook(55, i)] = startVelocities[hook(47, pointID * 3 + 1)] * alpha + endVelocities[hook(48, pointID * 3 + 1)] * beta;
          vecZ[hook(56, i)] = startVelocities[hook(47, pointID * 3 + 2)] * alpha + endVelocities[hook(48, pointID * 3 + 2)] * beta;
        } else {
          int pointID = gConnectivities[hook(57, (nextCell << 2) | i)];
          vecX[hook(54, i)] = gStartVelocities[hook(58, pointID * 3)] * alpha + gEndVelocities[hook(59, pointID * 3)] * beta;
          vecY[hook(55, i)] = gStartVelocities[hook(58, pointID * 3 + 1)] * alpha + gEndVelocities[hook(59, pointID * 3 + 1)] * beta;
          vecZ[hook(56, i)] = gStartVelocities[hook(58, pointID * 3 + 2)] * alpha + gEndVelocities[hook(59, pointID * 3 + 2)] * beta;
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

      currK[hook(60, 0)] = currK[hook(60, 1)] = currK[hook(60, 2)] = 0;

      for (int i = 0; i < 4; i++) {
        currK[hook(60, 0)] += vecX[hook(54, i)] * coordinates[hook(42, i)];
        currK[hook(60, 1)] += vecY[hook(55, i)] * coordinates[hook(42, i)];
        currK[hook(60, 2)] += vecZ[hook(56, i)] * coordinates[hook(42, i)];
      }

      currK[hook(60, 0)] *= timeStep;
      currK[hook(60, 1)] *= timeStep;
      currK[hook(60, 2)] *= timeStep;

      if (currStage == 3) {
        currTime += timeStep;

        for (int i = 0; i < 3; i++)
          currLastPosition[hook(49, i)] += (currK1[hook(50, i)] + 2 * currK2[hook(51, i)] + 2 * currK3[hook(52, i)] + currK4[hook(61, i)]) / 6;

        currStage = 0;
      } else
        currStage++;
    }
  }
}