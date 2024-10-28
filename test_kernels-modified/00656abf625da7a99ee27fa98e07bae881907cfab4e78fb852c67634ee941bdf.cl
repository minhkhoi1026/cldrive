//{"bounds":3,"count":5,"dir":1,"o":2,"size":6,"tHit":4,"vertex":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void IntersectionRP(const global float* vertex, const global float* dir, const global float* o, const global float* bounds, global unsigned char* tHit, int count, int size) {
  int iGID = get_global_id(0);
  if (iGID >= size)
    return;

  float4 e1, e2, s1, s2, d;
  float divisor, invDivisor, b1, b2, t;

  float4 v1, v2, v3, rayd, rayo;
  v1 = (float4)(vertex[hook(0, 9 * iGID)], vertex[hook(0, 9 * iGID + 1)], vertex[hook(0, 9 * iGID + 2)], 0);
  v2 = (float4)(vertex[hook(0, 9 * iGID + 3)], vertex[hook(0, 9 * iGID + 4)], vertex[hook(0, 9 * iGID + 5)], 0);
  v3 = (float4)(vertex[hook(0, 9 * iGID + 6)], vertex[hook(0, 9 * iGID + 7)], vertex[hook(0, 9 * iGID + 8)], 0);
  e1 = v2 - v1;
  e2 = v3 - v1;

  for (int i = 0; i < count; i++) {
    if (tHit[hook(4, i)] == '1')
      continue;
    rayd = (float4)(dir[hook(1, 3 * i)], dir[hook(1, 3 * i + 1)], dir[hook(1, 3 * i + 2)], 0);
    rayo = (float4)(o[hook(2, 3 * i)], o[hook(2, 3 * i + 1)], o[hook(2, 3 * i + 2)], 0);
    s1 = cross(rayd, e2);
    divisor = dot(s1, e1);
    if (divisor == 0.0)
      continue;
    invDivisor = 1.0f / divisor;

    d = rayo - v1;
    b1 = dot(d, s1) * invDivisor;
    if (b1 < -1e-3f || b1 > 1. + 1e-3f)
      continue;

    s2 = cross(d, e1);
    b2 = dot(rayd, s2) * invDivisor;
    if (b2 < -1e-3f || (b1 + b2) > 1. + 1e-3f)
      continue;

    t = dot(e2, s2) * invDivisor;
    if (t < bounds[hook(3, i * 2)])
      continue;
    if (tHit[hook(4, i)] != (__builtin_inff()) && tHit[hook(4, i)] != __builtin_astype((2147483647), float) && t > tHit[hook(4, i)])
      continue;
    tHit[hook(4, i)] = '1';
  }
}