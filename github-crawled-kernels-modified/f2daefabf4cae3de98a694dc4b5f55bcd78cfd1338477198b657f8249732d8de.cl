//{"bounds":5,"changed":8,"cones":3,"count":4,"counts":2,"dir":0,"index":7,"o":1,"tHit":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void intersectPAllLeaves(const global float* dir, const global float* o, const global float* bounds, global unsigned char* tHit, float3 v1, float3 v2, float3 v3, float3 e1, float3 e2, int chunk, int rindex) {
  float3 s1, s2, d, rayd, rayo;
  float divisor, invDivisor, t, b1, b2;

  for (int i = 0; i < chunk; i++) {
    rayd = (float3)(dir[hook(0, 3 * rindex + 3 * i)], dir[hook(0, 3 * rindex + 3 * i + 1)], dir[hook(0, 3 * rindex + 3 * i + 2)]);
    rayo = (float3)(o[hook(1, 3 * rindex + 3 * i)], o[hook(1, 3 * rindex + 3 * i + 1)], o[hook(1, 3 * rindex + 3 * i + 2)]);
    s1 = cross(rayd, e2);
    divisor = dot(s1, e1);
    if (divisor == 0.0f)
      continue;
    invDivisor = 1.0f / divisor;

    d = rayo - v1;
    b1 = dot(d, s1) * invDivisor;
    if (b1 < -1e-3f || b1 > 1 + 1e-3f)
      continue;

    s2 = cross(d, e1);
    b2 = dot(rayd, s2) * invDivisor;
    if (b2 < -1e-3f || (b1 + b2) > 1 + 1e-3f)
      continue;

    t = dot(e2, s2) * invDivisor;
    if (t < bounds[hook(5, 2 * rindex + i * 2)])
      continue;

    tHit[hook(6, rindex + i)] = '1';
  }
}

void intersectAllLeaves(const global float* dir, const global float* o, const global float* bounds, global int* index, global float* tHit, float3 v1, float3 v2, float3 v3, float3 e1, float3 e2, int chunk, int rindex

) {
  float3 s1, s2, d, rayd, rayo;
  float divisor, invDivisor, t, b1, b2;

  for (int i = 0; i < chunk; i++) {
    rayd = (float3)(dir[hook(0, 3 * rindex + 3 * i)], dir[hook(0, 3 * rindex + 3 * i + 1)], dir[hook(0, 3 * rindex + 3 * i + 2)]);
    rayo = (float3)(o[hook(1, 3 * rindex + 3 * i)], o[hook(1, 3 * rindex + 3 * i + 1)], o[hook(1, 3 * rindex + 3 * i + 2)]);

    s1 = cross(rayd, e2);
    divisor = dot(s1, e1);
    if (divisor == 0.0f)
      continue;
    invDivisor = 1.0f / divisor;

    d = rayo - v1;
    b1 = dot(d, s1) * invDivisor;
    if (b1 < -1e-3f || b1 > 1 + 1e-3f)
      continue;

    s2 = cross(d, e1);
    b2 = dot(rayd, s2) * invDivisor;
    if (b2 < -1e-3f || (b1 + b2) > 1 + 1e-3f)
      continue;

    t = dot(e2, s2) * invDivisor;
    if (t < bounds[hook(5, 2 * rindex + i * 2)])
      continue;

    if (t > tHit[hook(6, rindex + i)])
      continue;
    tHit[hook(6, rindex + i)] = t;
    index[hook(7, rindex + i)] = get_global_id(0);
  }
}

void yetAnotherIntersectAllLeaves(const global float* dir, const global float* o, const global float* bounds, global int* index, global float* tHit, global int* changed, float3 v1, float3 v2, float3 v3, float3 e1, float3 e2, int chunk, int rindex) {
  float3 s1, s2, d, rayd, rayo;
  float divisor, invDivisor, t, b1, b2;

  for (int i = 0; i < chunk; i++) {
    rayd = (float3)(dir[hook(0, 3 * rindex + 3 * i)], dir[hook(0, 3 * rindex + 3 * i + 1)], dir[hook(0, 3 * rindex + 3 * i + 2)]);
    rayo = (float3)(o[hook(1, 3 * rindex + 3 * i)], o[hook(1, 3 * rindex + 3 * i + 1)], o[hook(1, 3 * rindex + 3 * i + 2)]);

    s1 = cross(rayd, e2);
    divisor = dot(s1, e1);
    if (divisor == 0.0f)
      continue;
    invDivisor = 1.0f / divisor;

    d = rayo - v1;
    b1 = dot(d, s1) * invDivisor;
    if (b1 < -1e-3f || b1 > 1 + 1e-3f)
      continue;

    s2 = cross(d, e1);
    b2 = dot(rayd, s2) * invDivisor;
    if (b2 < -1e-3f || (b1 + b2) > 1 + 1e-3f)
      continue;

    t = dot(e2, s2) * invDivisor;
    if (t < bounds[hook(5, 2 * rindex + i * 2)])
      continue;

    if (t > tHit[hook(6, rindex + i)])
      continue;
    tHit[hook(6, rindex + i)] = t;
    index[hook(7, rindex + i)] = get_global_id(0);
    changed[hook(8, get_global_id(0))] = 1;
  }
}

kernel void rayhconstruct(const global float* dir, const global float* o, const global unsigned int* counts, global float* cones, const int count) {
  int iGID = get_global_id(0);
  if (iGID >= count)
    return;

  float3 x, r, q, c, p, a, e, n, g;
  float cosfi, sinfi;
  float dotrx, dotcx, t;

  unsigned int index = 0;
  for (int i = 0; i < iGID; i++)
    index += counts[hook(2, i)];

  x = normalize((float3)(dir[hook(0, 3 * index)], dir[hook(0, 3 * index + 1)], dir[hook(0, 3 * index + 2)]));
  a = (float3)(o[hook(1, 3 * index)], o[hook(1, 3 * index + 1)], o[hook(1, 3 * index + 2)]);
  cosfi = 1;

  for (int i = 1; i < counts[hook(2, iGID)]; i++) {
    r = normalize((float3)(dir[hook(0, 3 * (index + i))], dir[hook(0, 3 * (index + i) + 1)], dir[hook(0, 3 * (index + i) + 2)]));
    p = (float3)(o[hook(1, 3 * (index + i))], o[hook(1, 3 * (index + i) + 1)], o[hook(1, 3 * (index + i) + 2)]);
    dotrx = dot(r, x);
    if (dotrx < cosfi) {
      q = normalize(dotrx * x - r);
      sinfi = (cosfi > (1 - 0.000002f)) ? 0 : native_sin(acos(cosfi));
      e = normalize(x * cosfi + q * sinfi);
      x = normalize(e + r);

      cosfi = dot(x, r);
    }

    if (length(p - a) > 0.000002f) {
      c = normalize(p - a);
      dotcx = dot(c, x);
      if (dotcx < cosfi) {
        q = (dotcx * x - c) / length(dotcx * x - x);
        sinfi = native_sin(acos(cosfi));
        e = x * cosfi + q * sinfi;
        n = x * cosfi - q * sinfi;
        g = c - dot(n, c) * n;
        t = (length(g) * length(g)) / dot(e, g);
        a = a - t * e;
      }
    }
  }

  cones[hook(3, 8 * iGID)] = a.x;
  cones[hook(3, 8 * iGID + 1)] = a.y;
  cones[hook(3, 8 * iGID + 2)] = a.z;
  cones[hook(3, 8 * iGID + 3)] = x.x;
  cones[hook(3, 8 * iGID + 4)] = x.y;
  cones[hook(3, 8 * iGID + 5)] = x.z;
  cones[hook(3, 8 * iGID + 6)] = (cosfi > (1 - 0.000002f)) ? 0.003f : acos(cosfi);
  cones[hook(3, 8 * iGID + 7)] = counts[hook(2, iGID)];
}