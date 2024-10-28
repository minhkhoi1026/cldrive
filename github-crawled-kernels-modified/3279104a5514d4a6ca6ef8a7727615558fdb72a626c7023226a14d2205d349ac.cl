//{"atomInfo":0,"energyGrid":3,"gridSpacing":2,"numberOfAtoms":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void directCoulombSumReference(global float4* atomInfo, int numberOfAtoms, float gridSpacing, global float* energyGrid) {
  int xIndex = get_global_id(0);
  int yIndex = get_global_id(1);

  int outIndex = get_global_size(0) * yIndex + xIndex;

  float currentEnergy = energyGrid[hook(3, outIndex)];

  float coordX = gridSpacing * xIndex;
  float coordY = gridSpacing * yIndex;
  float energyValue = 0.0f;

  for (int i = 0; i < numberOfAtoms; i++) {
    float distanceX = coordX - atomInfo[hook(0, i)].x;
    float distanceY = coordY - atomInfo[hook(0, i)].y;
    float partialResult = half_rsqrt(distanceX * distanceX + distanceY * distanceY + atomInfo[hook(0, i)].z);
    energyValue += atomInfo[hook(0, i)].w * partialResult;
  }

  energyGrid[hook(3, outIndex)] += currentEnergy + energyValue;
}