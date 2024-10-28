//{"allpAABB":1,"numObjects":0,"pHash":3,"pParams":4,"smallAabbMapping":2}
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
  gridPos.x = (int)floor(worldPos.x * pParams[hook(4, 0)].x) & (gridDim.x - 1);
  gridPos.y = (int)floor(worldPos.y * pParams[hook(4, 0)].y) & (gridDim.y - 1);
  gridPos.z = (int)floor(worldPos.z * pParams[hook(4, 0)].z) & (gridDim.z - 1);
  return gridPos;
}

kernel void kCalcHashAABB(int numObjects, global float4* allpAABB, global const int* smallAabbMapping, global int2* pHash, global float4* pParams) {
  int index = get_global_id(0);
  if (index >= numObjects) {
    return;
  }
  float4 bbMin = allpAABB[hook(1, smallAabbMapping[ihook(2, index) * 2)];
  float4 bbMax = allpAABB[hook(1, smallAabbMapping[ihook(2, index) * 2 + 1)];
  float4 pos;
  pos.x = (bbMin.x + bbMax.x) * 0.5f;
  pos.y = (bbMin.y + bbMax.y) * 0.5f;
  pos.z = (bbMin.z + bbMax.z) * 0.5f;
  pos.w = 0.f;

  int4 gridPos = getGridPos(pos, pParams);
  int gridHash = getPosHash(gridPos, pParams);

  int2 hashVal;
  hashVal.x = gridHash;
  hashVal.y = index;
  pHash[hook(3, index)] = hashVal;
}