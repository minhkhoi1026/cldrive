//{"inputLors":2,"intensityBuffer":4,"nAxial":0,"nTransAxial":1,"outputLors":3}
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

  return intensityBuffer[hook(4, x + y * resolution + z * resolution * resolution)];
}

kernel void parallelProjection(const int nAxial, const int nTransAxial, global float* inputLors, global float* outputLors) {
  int iPair = get_global_id(0);
  int iAxial = get_global_id(1);
  int iTransAxial = get_global_id(2);

  int lorIndex = getLorIndex(iPair, iAxial, iAxial, iTransAxial, nTransAxial - iTransAxial - 1, nAxial, nTransAxial);
  int parallelIndex = iAxial + iTransAxial * nAxial + iPair * nAxial * nTransAxial;

  outputLors[hook(3, parallelIndex)] = inputLors[hook(2, lorIndex)];
}