//{"detectorArea":3,"estimatedLors":8,"intensityBuffer":11,"measuredLors":7,"measurementGeneration":10,"modules":6,"nAxial":0,"nTransAxial":1,"resolution":2,"volumeBuffer":9,"volumeMax":5,"volumeMin":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int intersectBox(float4 r_o, float4 r_d, float4 boxmin, float4 boxmax, float* tnear, float* tfar) {
  float4 invR = (float4)(1.0f, 1.0f, 1.0f, 1.0f) / r_d;
  float4 tbot = invR * (boxmin - r_o);
  float4 ttop = invR * (boxmax - r_o);

  float4 tmin = min(ttop, tbot);
  float4 tmax = max(ttop, tbot);

  float largest_tmin = max(max(tmin.x, tmin.y), max(tmin.x, tmin.z));
  float smallest_tmax = min(min(tmax.x, tmax.y), min(tmax.x, tmax.z));

  *tnear = largest_tmin;
  *tfar = smallest_tmax;

  return smallest_tmax > largest_tmin;
}

struct module {
  float4 origin;
  float4 axial;
  float4 transAxial;
  float4 n;
};

int getLorIndex(int pair, int axial1, int axial2, int transAxial1, int transAxial2, int nAxial, int nTransAxial) {
  int lorNumber = nAxial * nAxial * nTransAxial * nTransAxial;
  int u = axial1 * nTransAxial + transAxial1;
  int v = axial2 * nTransAxial + transAxial2;
  return lorNumber * pair + u * nAxial * nTransAxial + v;
}

int2 getModules(int pair) {
  switch (pair) {
    case 0:
      return (int2)(0, 2);
    case 1:
      return (int2)(1, 3);
  };
  return (int2)(0, 0);
}

float getIntensity(const float4 p, const int resolution, global float* intensityBuffer) {
  int x = p.x * resolution;
  int y = p.y * resolution;
  int z = p.z * resolution;

  if (x > resolution - 1 || x < 0)
    return (0.0f);
  if (y > resolution - 1 || y < 0)
    return (0.0f);
  if (z > resolution - 1 || z < 0)
    return (0.0f);

  return intensityBuffer[hook(11, x + y * resolution + z * resolution * resolution)];
}

kernel void forwardProjection(const int nAxial, const int nTransAxial, const int resolution, const float detectorArea, float4 volumeMin, float4 volumeMax, global struct module* modules, global float* measuredLors, global float* estimatedLors, global float* volumeBuffer, int measurementGeneration) {
  int iPair = get_global_id(0);
  int iAxial1 = get_global_id(1) % nAxial;
  int iTransAxial1 = get_global_id(1) / nAxial;
  int iAxial2 = get_global_id(2) % nAxial;
  int iTransAxial2 = get_global_id(2) / nAxial;

  int lorIndex = getLorIndex(iPair, iAxial1, iAxial2, iTransAxial1, iTransAxial2, nAxial, nTransAxial);

  float y_estimated = 0.0f;
  int2 iModule = getModules(iPair);
  float4 z1 = modules[hook(6, iModule.x)].origin + modules[hook(6, iModule.x)].transAxial * (iTransAxial1 + 0.5f) / nTransAxial + modules[hook(6, iModule.x)].axial * (iAxial1 + 0.5f) / nAxial;
  float4 z2 = modules[hook(6, iModule.y)].origin + modules[hook(6, iModule.y)].transAxial * (iTransAxial2 + 0.5f) / nTransAxial + modules[hook(6, iModule.y)].axial * (iAxial2 + 0.5f) / nAxial;
  float4 dir = z2 - z1;

  float tnear, tfar;

  if (intersectBox(z1, dir, volumeMin, volumeMax, &tnear, &tfar)) {
    float G = -detectorArea * detectorArea * dot(modules[hook(6, iModule.x)].n, dir) * dot(modules[hook(6, iModule.y)].n, dir) / (2.0f * 3.14159265358979323846f * dot(dir, dir) * dot(dir, dir));

    float4 start = z1 + tnear * dir;
    float4 end = z1 + tfar * dir;
    float4 step = (end - start) / resolution;
    float dl = length(step);

    float4 voxel = start;
    for (int i = 0; i < resolution; ++i) {
      float x = getIntensity((voxel - volumeMin) / (volumeMax - volumeMin), resolution, volumeBuffer);
      y_estimated += G * x * dl;
      voxel += step;
    }
  }

  if (0.0f != y_estimated) {
    if (measurementGeneration)
      measuredLors[hook(7, lorIndex)] = y_estimated;
    else
      estimatedLors[hook(8, lorIndex)] = measuredLors[hook(7, lorIndex)] / y_estimated;
  } else
    estimatedLors[hook(8, lorIndex)] = 0.0f;
}