//{"h":4,"kParticleCount":0,"nx":1,"nxtpos":7,"ny":2,"nz":3,"partIdx":6,"pos":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sph_kernel_hashParticles(int kParticleCount, int nx, int ny, int nz, float h, global float4* pos, global uint2* partIdx, global float* nxtpos) {
  unsigned int gid = get_global_id(0);

  float3 tempPos;

  float _2h = 2 * h;
  float rangeRatioX = (nx * _2h - 0) / (1 - (-1));
  float rangeRatioY = (ny * _2h - 0) / (1 - (-1));
  float rangeRatioZ = (nz * _2h - 0) / (1 - (-1));

  tempPos.x = (pos[hook(5, gid)].x - (-1)) * rangeRatioX;
  tempPos.y = (pos[hook(5, gid)].y - (-1)) * rangeRatioY;
  tempPos.z = (pos[hook(5, gid)].z - (-1)) * rangeRatioZ;

  float3 voxel3d;
  voxel3d.x = tempPos.x / _2h;
  voxel3d.y = tempPos.y / _2h;
  voxel3d.z = tempPos.z / _2h;

  float voxelID = voxel3d.x + voxel3d.y * nx + voxel3d.z * nx * ny;

  pos[hook(5, gid)].w = voxelID;

  partIdx[hook(6, gid)].x = floor(voxelID);
  partIdx[hook(6, gid)].y = gid;

  nxtpos[hook(7, 4 * gid + 0)] = pos[hook(5, gid)].x;
  nxtpos[hook(7, 4 * gid + 1)] = pos[hook(5, gid)].y;
  nxtpos[hook(7, 4 * gid + 2)] = pos[hook(5, gid)].z;
  nxtpos[hook(7, 4 * gid + 3)] = pos[hook(5, gid)].w;
}