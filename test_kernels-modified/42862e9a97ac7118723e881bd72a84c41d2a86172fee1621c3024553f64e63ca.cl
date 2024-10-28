//{"cellSize":7,"kEpsilon":11,"kParticleCount":0,"maxNeighbors":10,"neighborMap":9,"nx":4,"ny":5,"nz":6,"pos":8,"viewD":3,"viewH":2,"viewW":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sph_kernel_findNeighbors(int kParticleCount, float viewW, float viewH, float viewD, int nx, int ny, int nz, float cellSize, global float4* pos, global int* neighborMap, int maxNeighbors, float kEpsilon) {
  size_t gid = get_global_id(0);

  float3 myPos = pos[hook(8, gid)].xyz;

  int count = 0;
  int i;
  int j;

  for (i = 0; i < maxNeighbors; i++) {
    neighborMap[hook(9, maxNeighbors * gid + i)] = gid;
  }

  for (j = 0; j < kParticleCount; j++) {
    float3 particleJ = pos[hook(8, j)].xyz;
    float dist = length(myPos.xyz - particleJ);

    if ((dist >= kEpsilon) && (dist <= cellSize) && (j >= 0) && ((unsigned int)j != gid)) {
      neighborMap[hook(9, maxNeighbors * gid + count)] = j;
      count++;
      if (count == maxNeighbors)
        break;
    }
  }
}