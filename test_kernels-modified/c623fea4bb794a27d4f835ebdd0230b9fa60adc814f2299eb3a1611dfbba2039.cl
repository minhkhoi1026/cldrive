//{"cellSize":1,"density":11,"kEpsilon":8,"kNearNorm":3,"kNearStiffness":6,"kNorm":2,"kRestDensity":7,"kStiffness":5,"m":0,"maxNeighbors":4,"nearDensity":12,"nearPressure":14,"neighborMap":10,"pos":9,"pressure":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sph_kernel_pressure(float m, float cellSize, float kNorm, float kNearNorm, int maxNeighbors, float kStiffness, float kNearStiffness, float kRestDensity, float kEpsilon, global float4* pos, global int* neighborMap, global float* density, global float* nearDensity, global float* pressure, global float* nearPressure) {
  size_t gid = get_global_id(0);

  float3 myPos = pos[hook(9, gid)].xyz;

  int i;
  float3 posJ;
  float tempDens = 0.0;
  float tempNearDens = 0.0;

  for (i = 0; i < maxNeighbors; i++) {
    int nID = neighborMap[hook(10, maxNeighbors * gid + i)];
    if ((nID >= 0) && ((unsigned int)nID == gid))
      continue;

    posJ = pos[hook(9, nID)].xyz;

    float r = length(myPos - posJ);

    float a = 1 - r / cellSize;

    tempDens += m * a * a * a * kNorm;
    tempNearDens += m * a * a * a * a * kNearNorm;
  }

  density[hook(11, gid)] = tempDens;
  nearDensity[hook(12, gid)] = tempNearDens;
  pressure[hook(13, gid)] = kStiffness * (tempDens - m * kRestDensity);
  nearPressure[hook(14, gid)] = kNearStiffness * tempNearDens;
}