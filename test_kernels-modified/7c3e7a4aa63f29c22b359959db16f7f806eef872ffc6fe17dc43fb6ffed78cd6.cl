//{"energies":0,"indices":2,"indicesCount":3,"limit":5,"maximalEnergy":6,"n":4,"patchesCount":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float formFactor(float4 RecvPos, float4 ShootPos, float4 RecvNormal, float4 ShootNormal, float ShootDArea) {
  float pi = (float)3.14159265358979323846f;

  if (ShootPos.x == RecvPos.x && ShootPos.y == RecvPos.y && ShootPos.z == RecvPos.z) {
    return 0.0;
  }

  float4 r = ShootPos - RecvPos;

  float distance2 = dot(r, r);
  r = normalize(r);

  float cosi = dot(RecvNormal, r);
  float cosj = -dot(ShootNormal, r);

  return (max(cosi * cosj, 0.0f) / (pi * distance2)) * ShootDArea;
}

kernel void sort(global float* energies, unsigned int patchesCount, global unsigned int* indices, global unsigned int* indicesCount, unsigned int n, float limit, global float* maximalEnergy) {
  int count = 0;
  unsigned int pos = 0;
  unsigned int maxPos = patchesCount;
  float max = 0.0f;
  float lastMax = 10000000.0f;
  float lastMaxOld = lastMax;

  for (int i = 0; i < n; i++) {
    max = 0.0;
    int j;
    for (j = 0; j < maxPos; j++) {
      float energy = energies[hook(0, j)];
      if (energy >= max && energy < lastMax) {
        pos = j;
        max = energy;
      }
    }

    if (i == 0) {
      maximalEnergy[hook(6, 0)] = max;
    }

    if (max == 0.0 || max < limit) {
      if (j == maxPos) {
        break;
      }

      lastMax = lastMaxOld;
      maxPos = patchesCount;
      continue;
    }

    indices[hook(2, i)] = pos;
    count++;
    maxPos = pos;
    lastMaxOld = max;
  }

  indicesCount[hook(3, 0)] = count;
}