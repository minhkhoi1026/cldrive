//{"numCells":0,"pCellStart":1,"pParams":2}
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
  gridPos.x = (int)floor(worldPos.x * pParams[hook(2, 0)].x) & (gridDim.x - 1);
  gridPos.y = (int)floor(worldPos.y * pParams[hook(2, 0)].y) & (gridDim.y - 1);
  gridPos.z = (int)floor(worldPos.z * pParams[hook(2, 0)].z) & (gridDim.z - 1);
  return gridPos;
}

kernel void kClearCellStart(int numCells, global int* pCellStart) {
  int index = get_global_id(0);
  if (index >= numCells) {
    return;
  }
  pCellStart[hook(1, index)] = -1;
}