//{"cellSize":6,"nx":3,"ny":4,"nz":5,"partIdx":8,"pos":7,"vel":9,"viewDepth":2,"viewHeight":1,"viewWidth":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sph_kernel_hashparticles(float viewWidth, float viewHeight, float viewDepth, int nx, int ny, int nz, float cellSize, global float4* pos, global uint2* partIdx, global float4* vel) {
  size_t gid = get_global_id(0);

  float3 tempPos;

  float rangeRatioX = (nx * cellSize - 0.0f) / viewWidth;
  float rangeRatioY = (ny * cellSize - 0.0f) / viewHeight;
  float rangeRatioZ = (nz * cellSize - 0.0f) / viewDepth;

  tempPos.x = (pos[hook(7, gid)].x - (-viewWidth / 2)) * rangeRatioX;
  tempPos.y = (pos[hook(7, gid)].y - (-viewHeight / 2)) * rangeRatioY;
  tempPos.z = (pos[hook(7, gid)].z - (-viewDepth / 2)) * rangeRatioZ;

  float3 voxel3d;
  voxel3d.x = tempPos.x / cellSize;
  voxel3d.y = tempPos.y / cellSize;
  voxel3d.z = tempPos.z / cellSize;

  int voxelID = floor(voxel3d.x) + floor(voxel3d.y) * nx + floor(voxel3d.z) * nx * ny;

  pos[hook(7, gid)].w = voxelID;

  partIdx[hook(8, gid)].x = voxelID;
  partIdx[hook(8, gid)].y = gid;
}