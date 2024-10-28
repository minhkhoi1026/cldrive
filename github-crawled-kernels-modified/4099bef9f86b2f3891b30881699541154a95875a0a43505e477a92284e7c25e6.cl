//{"bounds":6,"changed":9,"cones":0,"count":1,"dir":4,"index":8,"level":3,"o":5,"tHit":7,"threadsCount":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void intersectPAllLeaves(const global float* dir, const global float* o, const global float* bounds, global unsigned char* tHit, float3 v1, float3 v2, float3 v3, float3 e1, float3 e2, int chunk, int rindex) {
  float3 s1, s2, d, rayd, rayo;
  float divisor, invDivisor, t, b1, b2;

  for (int i = 0; i < chunk; i++) {
    rayd = (float3)(dir[hook(4, 3 * rindex + 3 * i)], dir[hook(4, 3 * rindex + 3 * i + 1)], dir[hook(4, 3 * rindex + 3 * i + 2)]);
    rayo = (float3)(o[hook(5, 3 * rindex + 3 * i)], o[hook(5, 3 * rindex + 3 * i + 1)], o[hook(5, 3 * rindex + 3 * i + 2)]);
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
    if (t < bounds[hook(6, 2 * rindex + i * 2)])
      continue;

    tHit[hook(7, rindex + i)] = '1';
  }
}

void intersectAllLeaves(const global float* dir, const global float* o, const global float* bounds, global int* index, global float* tHit, float3 v1, float3 v2, float3 v3, float3 e1, float3 e2, int chunk, int rindex

) {
  float3 s1, s2, d, rayd, rayo;
  float divisor, invDivisor, t, b1, b2;

  for (int i = 0; i < chunk; i++) {
    rayd = (float3)(dir[hook(4, 3 * rindex + 3 * i)], dir[hook(4, 3 * rindex + 3 * i + 1)], dir[hook(4, 3 * rindex + 3 * i + 2)]);
    rayo = (float3)(o[hook(5, 3 * rindex + 3 * i)], o[hook(5, 3 * rindex + 3 * i + 1)], o[hook(5, 3 * rindex + 3 * i + 2)]);

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
    if (t < bounds[hook(6, 2 * rindex + i * 2)])
      continue;

    if (t > tHit[hook(7, rindex + i)])
      continue;
    tHit[hook(7, rindex + i)] = t;
    index[hook(8, rindex + i)] = get_global_id(0);
  }
}

void yetAnotherIntersectAllLeaves(const global float* dir, const global float* o, const global float* bounds, global int* index, global float* tHit, global int* changed, float3 v1, float3 v2, float3 v3, float3 e1, float3 e2, int chunk, int rindex) {
  float3 s1, s2, d, rayd, rayo;
  float divisor, invDivisor, t, b1, b2;

  for (int i = 0; i < chunk; i++) {
    rayd = (float3)(dir[hook(4, 3 * rindex + 3 * i)], dir[hook(4, 3 * rindex + 3 * i + 1)], dir[hook(4, 3 * rindex + 3 * i + 2)]);
    rayo = (float3)(o[hook(5, 3 * rindex + 3 * i)], o[hook(5, 3 * rindex + 3 * i + 1)], o[hook(5, 3 * rindex + 3 * i + 2)]);

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
    if (t < bounds[hook(6, 2 * rindex + i * 2)])
      continue;

    if (t > tHit[hook(7, rindex + i)])
      continue;
    tHit[hook(7, rindex + i)] = t;
    index[hook(8, rindex + i)] = get_global_id(0);
    changed[hook(9, get_global_id(0))] = 1;
  }
}

kernel void levelConstruct(global float* cones, const int count, const int threadsCount, const int level) {
  int iGID = get_global_id(0);

  int beginr = 0;
  int beginw = 0;
  int levelcount = threadsCount;
  int temp;

  for (int i = 0; i < level; i++) {
    beginw += levelcount;
    temp = levelcount;
    levelcount = (levelcount + 1) / 2;
  }
  beginr = beginw - temp;

  if (iGID >= levelcount)
    return;

  float3 x, q, c, a, g, xb, ab, e, n;
  float cosfi, sinfi, cosfib;
  float dotrx, dotcx, t;
  float fi, fib;

  x = (float3)(cones[hook(0, 8 * beginr + 16 * iGID + 3)], cones[hook(0, 8 * beginr + 16 * iGID + 4)], cones[hook(0, 8 * beginr + 16 * iGID + 5)]);
  a = (float3)(cones[hook(0, 8 * beginr + 16 * iGID)], cones[hook(0, 8 * beginr + 16 * iGID + 1)], cones[hook(0, 8 * beginr + 16 * iGID + 2)]);
  fi = cones[hook(0, 8 * beginr + 16 * iGID + 6)];
  cosfi = native_cos(fi);
  cones[hook(0, 8 * beginw + 8 * iGID + 7)] = 1;
  if (!(iGID == (levelcount - 1) && temp % 2 == 1)) {
    cones[hook(0, 8 * beginw + 8 * iGID + 7)] = 2;
    ab = (float3)(cones[hook(0, 8 * beginr + 16 * iGID + 8)], cones[hook(0, 8 * beginr + 16 * iGID + 9)], cones[hook(0, 8 * beginr + 16 * iGID + 10)]);
    xb = (float3)(cones[hook(0, 8 * beginr + 16 * iGID + 11)], cones[hook(0, 8 * beginr + 16 * iGID + 12)], cones[hook(0, 8 * beginr + 16 * iGID + 13)]);
    fib = cones[hook(0, 8 * beginr + 16 * iGID + 13)];
    cosfib = native_cos(fib);

    dotrx = dot(x, xb);
    if (dotrx < cosfib && dotrx < cosfi) {
      x = (x + xb) / length(x + xb);
      cosfi = native_cos(acos(dotrx) + min(fib, fi));
      fi = acos(cosfi);
    } else {
      if (fi < fib) {
        x = xb;
        a = ab;
        cosfi = cosfib;
        fi = fib;
      }
    }

    c = ab - a;
    if (length(c) > 0.000002f) {
      c = normalize(c);
      dotcx = dot(x, c);
      if (dotcx < cosfi) {
        q = (dotcx * x - c) / length(dotcx * x - x);
        sinfi = native_sin(fi);
        e = x * cosfi + q * sinfi;
        n = x * cosfi - q * sinfi;
        g = c - dot(n, c) * n;
        t = (length(g) * length(g)) / dot(e, g);
        a = a - t * e;
      }
    }
  }
  cones[hook(0, 8 * beginw + 8 * iGID)] = a.x;
  cones[hook(0, 8 * beginw + 8 * iGID + 1)] = a.y;
  cones[hook(0, 8 * beginw + 8 * iGID + 2)] = a.z;
  cones[hook(0, 8 * beginw + 8 * iGID + 3)] = x.x;
  cones[hook(0, 8 * beginw + 8 * iGID + 4)] = x.y;
  cones[hook(0, 8 * beginw + 8 * iGID + 5)] = x.z;
  cones[hook(0, 8 * beginw + 8 * iGID + 6)] = fi;
}