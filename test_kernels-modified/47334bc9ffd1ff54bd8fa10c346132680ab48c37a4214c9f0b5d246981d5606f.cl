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
  unsigned int cache_size = get_local_size(0);
  unsigned int id = get_local_id(0);
  unsigned int processed_vertices = 0;
  bool found_collision = false;

  while (processed_vertices < 3 * nTriangles) {
    if (processed_vertices + id < 3 * nTriangles) {
      lTriangleCache[hook(2, id)] = gTriangleSoup[hook(3, processed_vertices + id)];
    }

    barrier(0x01);

    for (int i = 0; i < cache_size / 3; i++) {
      float4 v0 = lTriangleCache[hook(2, 3 * i + 0)];
      v0.w = 0;
      float4 v1 = lTriangleCache[hook(2, 3 * i + 1)];
      v1.w = 0;
      float4 v2 = lTriangleCache[hook(2, 3 * i + 2)];
      v2.w = 0;

      float t_new;
      float4 n_new;
      if (LineTriangleIntersection(x0, x1, v0, v1, v2, &t_new, &n_new) && (!found_collision || t_new < *t)) {
        *t = t_new;
        *n = n_new;
        found_collision = true;
      }
    }

    barrier(0x01);

    processed_vertices += cache_size;
  }

  return found_collision;
}

float random(ulong seed) {
  seed = (seed * 0x5DEECE66DL + 0xBL) & ((1L << 48) - 1);
  return seed >> 16;
}
kernel void Clear(global float4* gPosLife, global float4* gVelMass) {
  unsigned int GID = get_global_id(0);
  gPosLife[hook(0, GID)] = 0.f;
  gVelMass[hook(1, GID)] = 0.f;
}