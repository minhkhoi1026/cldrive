//{"estimatedLors":7,"intensityBuffer":9,"modules":6,"nAxial":1,"nPairs":0,"nTransAxial":2,"resolution":3,"volumeBuffer":8,"volumeMax":5,"volumeMin":4}
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

  return intensityBuffer[hook(9, x + y * resolution + z * resolution * resolution)];
}

kernel void backProjection(const int nPairs, const int nAxial, const int nTransAxial, const int resolution, float4 volumeMin, float4 volumeMax, global struct module* modules, global float* estimatedLors, global float* volumeBuffer) {
  int4 iVoxel = (int4)(get_global_id(0), get_global_id(1), get_global_id(2), 0);
  int linearIndex = iVoxel.x + iVoxel.y * resolution + iVoxel.z * resolution * resolution;
  float4 voxel = (float4)(iVoxel.x, iVoxel.y, iVoxel.z, 0);
  voxel /= resolution;
  voxel = (volumeMax - volumeMin) * voxel + volumeMin;

  float numerator = 0.0f;
  float denominator = 0.0f;
  for (int iPair = 0; iPair < nPairs; ++iPair) {
    int2 iModule = getModules(iPair);
    struct module primary = modules[hook(6, iModule.x)];
    struct module secondary = modules[hook(6, iModule.y)];
    bool switchDetectors = false;
    if (dot(voxel - primary.origin, primary.n) < dot(voxel - secondary.origin, secondary.n)) {
      switchDetectors = true;
      struct module tmp;
      tmp = primary;
      primary = secondary;
      secondary = tmp;
    }

    float sTransAxial = nTransAxial / dot(secondary.transAxial, secondary.transAxial);
    float sAxial = nAxial / dot(secondary.axial, secondary.axial);
    for (int p = 0; p < nAxial; ++p)
      for (int q = 0; q < nTransAxial; ++q) {
        float4 z1 = primary.origin + primary.axial * (p + 0.5f) / nAxial + primary.transAxial * (q + 0.5f) / nTransAxial;
        float4 dv = voxel - z1;

        float t = dot(secondary.n, secondary.origin - z1) / dot(secondary.n, dv);
        float4 z2 = z1 + dv * t;

        float fr = dot(z2 - secondary.origin, secondary.axial) * sAxial;
        float fs = dot(z2 - secondary.origin, secondary.transAxial) * sTransAxial;
        if (0 <= fr && fr < nAxial && 0 <= fs && fs < nTransAxial) {
          int r = (int)fr;
          int s = (int)fs;

          int lorIndex;
          if (switchDetectors) {
            lorIndex = getLorIndex(iPair, r, p, s, q, nAxial, nTransAxial);
          } else {
            lorIndex = getLorIndex(iPair, p, r, q, s, nAxial, nTransAxial);
          }
          float y_div_yw = estimatedLors[hook(7, lorIndex)];
          float ddv = length(dv);
          float Alv = dot(primary.n, dv) / (ddv * ddv * ddv);

          numerator += y_div_yw * Alv;
          denominator += Alv;
        }
      }
  }

  if (denominator > 0.0f) {
    volumeBuffer[hook(8, linearIndex)] *= numerator / denominator;
  } else {
    volumeBuffer[hook(8, linearIndex)] = 0.0f;
  }
}