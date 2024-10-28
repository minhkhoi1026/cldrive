//{"allpAABB":1,"maxPairs":8,"numObjects":0,"pCellStart":4,"pHash":3,"pPairBuff2":7,"pParams":5,"pairCount":6,"smallAabbMapping":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int getPosHash(int4 gridPos, global float4* pParams) {
  int4 gridDim = *((global int4*)(pParams + 1));
  gridPos.x &= gridDim.x - 1;
  gridPos.y &= gridDim.y - 1;
  gridPos.z &= gridDim.z - 1;
  int hash = gridPos.z * gridDim.y * gridDim.x + gridPos.y * gridDim.x + gridPos.x;
  return hash;
}

int4 getGridPos(float4 worldPos, global float4* pParams) {
  int4 gridPos;
  int4 gridDim = *((global int4*)(pParams + 1));
  gridPos.x = (int)floor(worldPos.x * pParams[hook(5, 0)].x) & (gridDim.x - 1);
  gridPos.y = (int)floor(worldPos.y * pParams[hook(5, 0)].y) & (gridDim.y - 1);
  gridPos.z = (int)floor(worldPos.z * pParams[hook(5, 0)].z) & (gridDim.z - 1);
  return gridPos;
}

int testAABBOverlap(float4 min0, float4 max0, float4 min1, float4 max1) {
  return (min0.x <= max1.x) && (min1.x <= max0.x) && (min0.y <= max1.y) && (min1.y <= max0.y) && (min0.z <= max1.z) && (min1.z <= max0.z);
}

void findPairsInCell(int numObjects, int4 gridPos, int index, global int2* pHash, global int* pCellStart, global float4* allpAABB, global const int* smallAabbMapping, global float4* pParams, volatile global int* pairCount, global int4* pPairBuff2, int maxPairs) {
  int4 pGridDim = *((global int4*)(pParams + 1));
  int maxBodiesPerCell = pGridDim.w;
  int gridHash = getPosHash(gridPos, pParams);

  int bucketStart = pCellStart[hook(4, gridHash)];
  if (bucketStart == -1) {
    return;
  }

  int2 sortedData = pHash[hook(3, index)];
  int unsorted_indx = sortedData.y;
  float4 min0 = allpAABB[hook(1, smallAabbMapping[uhook(2, unsorted_indx) * 2 + 0)];
  float4 max0 = allpAABB[hook(1, smallAabbMapping[uhook(2, unsorted_indx) * 2 + 1)];
  int handleIndex = __builtin_astype((min0.w), int);

  int bucketEnd = bucketStart + maxBodiesPerCell;
  bucketEnd = (bucketEnd > numObjects) ? numObjects : bucketEnd;
  for (int index2 = bucketStart; index2 < bucketEnd; index2++) {
    int2 cellData = pHash[hook(3, index2)];
    if (cellData.x != gridHash) {
      break;
    }
    int unsorted_indx2 = cellData.y;

    if (unsorted_indx2 != unsorted_indx) {
      float4 min1 = allpAABB[hook(1, smallAabbMapping[uhook(2, unsorted_indx2) * 2 + 0)];
      float4 max1 = allpAABB[hook(1, smallAabbMapping[uhook(2, unsorted_indx2) * 2 + 1)];
      if (testAABBOverlap(min0, max0, min1, max1)) {
        if (pairCount) {
          int handleIndex2 = __builtin_astype((min1.w), int);
          if (handleIndex < handleIndex2) {
            int curPair = atomic_add(pairCount, 1);
            if (curPair < maxPairs) {
              int4 newpair;
              newpair.x = handleIndex;
              newpair.y = handleIndex2;
              newpair.z = -1;
              newpair.w = -1;
              pPairBuff2[hook(7, curPair)] = newpair;
            }
          }
        }
      }
    }
  }
}

kernel void kFindOverlappingPairs(int numObjects, global float4* allpAABB, global const int* smallAabbMapping, global int2* pHash, global int* pCellStart, global float4* pParams, volatile global int* pairCount, global int4* pPairBuff2, int maxPairs)

{
  int index = get_global_id(0);
  if (index >= numObjects) {
    return;
  }
  int2 sortedData = pHash[hook(3, index)];
  int unsorted_indx = sortedData.y;
  float4 bbMin = allpAABB[hook(1, smallAabbMapping[uhook(2, unsorted_indx) * 2 + 0)];
  float4 bbMax = allpAABB[hook(1, smallAabbMapping[uhook(2, unsorted_indx) * 2 + 1)];
  float4 pos;
  pos.x = (bbMin.x + bbMax.x) * 0.5f;
  pos.y = (bbMin.y + bbMax.y) * 0.5f;
  pos.z = (bbMin.z + bbMax.z) * 0.5f;

  int4 gridPosA = getGridPos(pos, pParams);
  int4 gridPosB;

  for (int z = -1; z <= 1; z++) {
    gridPosB.z = gridPosA.z + z;
    for (int y = -1; y <= 1; y++) {
      gridPosB.y = gridPosA.y + y;
      for (int x = -1; x <= 1; x++) {
        gridPosB.x = gridPosA.x + x;
        findPairsInCell(numObjects, gridPosB, index, pHash, pCellStart, allpAABB, smallAabbMapping, pParams, pairCount, pPairBuff2, maxPairs);
      }
    }
  }
}