//{"gPosLife":0,"gTriangleSoup":3,"gVelMass":1,"lTriangleCache":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 cross3(float4 a, float4 b) {
  float4 c;
  c.x = a.y * b.z - b.y * a.z;
  c.y = a.z * b.x - b.z * a.x;
  c.z = a.x * b.y - b.x * a.y;
  c.w = 0.f;
  return c;
}

float dot3(float4 a, float4 b) {
  return a.x * b.x + a.y * b.y + a.z * b.z;
}
bool LineTriangleIntersection(float4 x0, float4 x1, float4 v1, float4 v2, float4 v3, float* isectT, float4* isectN) {
  float4 dir = x1 - x0;
  dir.w = 0.f;

  float4 e1 = v2 - v1;
  float4 e2 = v3 - v1;
  e1.w = 0.f;
  e2.w = 0.f;

  float4 s1 = cross3(dir, e2);
  float divisor = dot3(s1, e1);
  if (divisor == 0.f)
    return false;
  float invDivisor = 1.f / divisor;

  float4 d = x0 - v1;
  float b1 = dot3(d, s1) * invDivisor;
  if (b1 < -0.001f || b1 > 1.f + 0.001f)
    return false;

  float4 s2 = cross3(d, e1);
  float b2 = dot3(dir, s2) * invDivisor;
  if (b2 < -0.001f || b1 + b2 > 1.f + 0.001f)
    return false;

  float t = dot3(e2, s2) * invDivisor;
  if (t < -0.001f || t > 1.f + 0.001f)
    return false;

  *isectT = t;
  *isectN = cross3(e1, e2);
  *isectN = normalize(*isectN);
  return true;
}

bool CheckCollisions(float4 x0, float4 x1, global float4* gTriangleSoup, local float4* lTriangleCache, unsigned int nTriangles, float* t, float4* n) {
  *t = 1.f + 0.001f;
  float isectT;
  float4 isectN;
  int LID = get_local_id(0);

  for (int count = 0; count < nTriangles * 3; count += get_local_size(0)) {
    if (LID + count < nTriangles * 3)
      lTriangleCache[hook(2, LID)] = gTriangleSoup[hook(3, LID + count)];
    barrier(0x01);
    int minimum = min((int)get_local_size(0) / 3, (int)nTriangles - count / 3);
    for (int i = 0; i < minimum; i++) {
      if (LineTriangleIntersection(x0, x1, lTriangleCache[hook(2, 3 * i)], lTriangleCache[hook(2, 3 * i + 1)], lTriangleCache[hook(2, 3 * i + 2)], &isectT, &isectN) && (isectT > 0.001f) && (isectT < *t)) {
        *t = isectT;
        *n = isectN;
      }
    }
  }
  if (*t < 1.f + 0.001f)
    return true;
  return false;
}

float4 rand(uint2* state) {
  const float4 invMaxInt = (float4)(1.0f / 4294967296.0f, 1.0f / 4294967296.0f, 1.0f / 4294967296.0f, 0);
  unsigned int x = (*state).x * 17 + (*state).y * 13123;
  (*state).x = (x << 13) ^ x;
  (*state).y ^= (x << 7);

  uint4 tmp = (uint4)((x * (x * x * 15731 + 74323) + 871483), (x * (x * x * 13734 + 37828) + 234234), (x * (x * x * 11687 + 26461) + 137589), 0);

  return convert_float4(tmp) * invMaxInt;
}
kernel void Clear(global float4* gPosLife, global float4* gVelMass) {
  unsigned int GID = get_global_id(0);
  gPosLife[hook(0, GID)] = 0.f;
  gVelMass[hook(1, GID)] = 0.f;
}