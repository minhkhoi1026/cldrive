//{"diffColors":6,"energies":5,"indices":3,"indicesCount":4,"intensities":7,"patchesColors":1,"patchesCount":2,"patchesGeo":0,"texture":8,"visited":9}
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

kernel void radiosity(global float8* patchesGeo, global uchar3* patchesColors, unsigned int patchesCount, global unsigned int* indices, global unsigned int* indicesCount, global float* energies, global uchar3* diffColors, global float* intensities, global uchar3* texture, global bool* visited) {
  int i = get_global_id(0);

  if (i >= indicesCount[hook(4, 0)]) {
    return;
  }

  unsigned int offset = i * 256;

  float8 lightGeo = patchesGeo[hook(0, indices[ihook(3, i))];
  uchar3 lightColor = patchesColors[hook(1, indices[ihook(3, i))];
  float lightEnergy = energies[hook(5, indices[ihook(3, i))];
  energies[hook(5, indices[ihook(3, i))] = 0;

  float x, y, z;

  float4 ShootPos = {lightGeo.s0, lightGeo.s1, lightGeo.s2, 0};

  x = lightGeo.s3;
  y = lightGeo.s4;
  z = lightGeo.s5;
  float4 ShootNormal = {x, y, z, 0};

  float ShootDArea = lightGeo.s6;

  for (unsigned int h = offset; h < offset + 256; h++) {
    for (unsigned int w = 0; w < 768; w++) {
      uchar3 texColor = texture[hook(8, w + h * 768)];
      int j = texColor.s2;
      j <<= 8;
      j |= texColor.s1;
      j <<= 8;
      j |= texColor.s0;

      if (j >= patchesCount || j < 0) {
        continue;
      }

      if (visited[hook(9, j + patchesCount * i)] == false) {
        float8 patchGeo = patchesGeo[hook(0, j)];
        float4 RecvPos = {patchGeo.s0, patchGeo.s1, patchGeo.s2, 0};

        x = patchGeo.s3;
        y = patchGeo.s4;
        z = patchGeo.s5;
        float4 RecvNormal = {x, y, z, 0};

        float delta = formFactor(RecvPos, ShootPos, RecvNormal, ShootNormal, ShootDArea);

        diffColors[hook(6, j)].s0 += lightColor.s0 * 0.5 * delta;
        diffColors[hook(6, j)].s1 += lightColor.s1 * 0.5 * delta;
        diffColors[hook(6, j)].s2 += lightColor.s2 * 0.5 * delta;

        energies[hook(5, j)] += lightEnergy * delta * 0.5;
        intensities[hook(7, j)] += lightEnergy * delta;

        visited[hook(9, j + patchesCount * i)] = true;
      }
    }
  }
}