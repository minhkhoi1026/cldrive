//{"cellStart":2,"numObjects":0,"pHash":1,"pParams":3,"sharedHash":4}
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
  gridPos.x = (int)floor(worldPos.x * pParams[hook(3, 0)].x) & (gridDim.x - 1);
  gridPos.y = (int)floor(worldPos.y * pParams[hook(3, 0)].y) & (gridDim.y - 1);
  gridPos.z = (int)floor(worldPos.z * pParams[hook(3, 0)].z) & (gridDim.z - 1);
  return gridPos;
}

kernel void kFindCellStart(int numObjects, global int2* pHash, global int* cellStart) {
  local int sharedHash[513];
  int index = get_global_id(0);
  int2 sortedData;

  if (index < numObjects) {
    sortedData = pHash[hook(1, index)];

    sharedHash[hook(4, get_local_id(0) + 1)] = sortedData.x;
    if ((index > 0) && (get_local_id(0) == 0)) {
      sharedHash[hook(4, 0)] = pHash[hook(1, index - 1)].x;
    }
  }
  barrier(0x01);
  if (index < numObjects) {
    if ((index == 0) || (sortedData.x != sharedHash[hook(4, get_local_id(0))])) {
      cellStart[hook(2, sortedData.x)] = index;
    }
  }
}