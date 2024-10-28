//{"atomInfo":0,"energyGrid":3,"gridSpacing":2,"numberOfAtoms":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void directCoulombSumReference(global float4* atomInfo, int numberOfAtoms, float gridSpacing, global float* energyGrid) {
  int xIndex = get_global_id(0);
  int yIndex = get_global_id(1);
  int zIndex = get_global_id(2);

  int outIndex = get_global_size(1) * get_global_size(0) * zIndex + get_global_size(0) * yIndex + xIndex;

  float coordX = gridSpacing * xIndex;
  float coordY = gridSpacing * yIndex;
  float coordZ = gridSpacing * zIndex;

  float energyValue = 0.0f;

  for (int i = 0; i < numberOfAtoms; i++) {
    float dX = coordX - atomInfo[hook(0, i)].x;
    float dY = coordY - atomInfo[hook(0, i)].y;
    float dZ = coordZ - atomInfo[hook(0, i)].z;
    float partialResult = half_rsqrt(dX * dX + dY * dY + dZ * dZ);
    energyValue += atomInfo[hook(0, i)].w * partialResult;
  }

  energyGrid[hook(3, outIndex)] += energyValue;
}