//{"bounds":4,"changed":13,"chunk":10,"cones":3,"count":8,"dir":1,"height":11,"index":6,"o":2,"size":9,"stack":7,"tHit":5,"threadsCount":12,"vertex":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void intersectPAllLeaves(const global float* dir, const global float* o, const global float* bounds, global unsigned char* tHit, float3 v1, float3 v2, float3 v3, float3 e1, float3 e2, int chunk, int rindex) {
  float3 s1, s2, d, rayd, rayo;
  float divisor, invDivisor, t, b1, b2;

  for (int i = 0; i < chunk; i++) {
    rayd = (float3)(dir[hook(1, 3 * rindex + 3 * i)], dir[hook(1, 3 * rindex + 3 * i + 1)], dir[hook(1, 3 * rindex + 3 * i + 2)]);
    rayo = (float3)(o[hook(2, 3 * rindex + 3 * i)], o[hook(2, 3 * rindex + 3 * i + 1)], o[hook(2, 3 * rindex + 3 * i + 2)]);
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
    if (t < bounds[hook(4, 2 * rindex + i * 2)])
      continue;

    tHit[hook(5, rindex + i)] = '1';
  }
}

void intersectAllLeaves(const global float* dir, const global float* o, const global float* bounds, global int* index, global float* tHit, float3 v1, float3 v2, float3 v3, float3 e1, float3 e2, int chunk, int rindex

) {
  float3 s1, s2, d, rayd, rayo;
  float divisor, invDivisor, t, b1, b2;

  for (int i = 0; i < chunk; i++) {
    rayd = (float3)(dir[hook(1, 3 * rindex + 3 * i)], dir[hook(1, 3 * rindex + 3 * i + 1)], dir[hook(1, 3 * rindex + 3 * i + 2)]);
    rayo = (float3)(o[hook(2, 3 * rindex + 3 * i)], o[hook(2, 3 * rindex + 3 * i + 1)], o[hook(2, 3 * rindex + 3 * i + 2)]);

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
    if (t < bounds[hook(4, 2 * rindex + i * 2)])
      continue;

    if (t > tHit[hook(5, rindex + i)])
      continue;
    tHit[hook(5, rindex + i)] = t;
    index[hook(6, rindex + i)] = get_global_id(0);
  }
}

void yetAnotherIntersectAllLeaves(const global float* dir, const global float* o, const global float* bounds, global int* index, global float* tHit, global int* changed, float3 v1, float3 v2, float3 v3, float3 e1, float3 e2, int chunk, int rindex) {
  float3 s1, s2, d, rayd, rayo;
  float divisor, invDivisor, t, b1, b2;

  for (int i = 0; i < chunk; i++) {
    rayd = (float3)(dir[hook(1, 3 * rindex + 3 * i)], dir[hook(1, 3 * rindex + 3 * i + 1)], dir[hook(1, 3 * rindex + 3 * i + 2)]);
    rayo = (float3)(o[hook(2, 3 * rindex + 3 * i)], o[hook(2, 3 * rindex + 3 * i + 1)], o[hook(2, 3 * rindex + 3 * i + 2)]);

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
    if (t < bounds[hook(4, 2 * rindex + i * 2)])
      continue;

    if (t > tHit[hook(5, rindex + i)])
      continue;
    tHit[hook(5, rindex + i)] = t;
    index[hook(6, rindex + i)] = get_global_id(0);
    changed[hook(13, get_global_id(0))] = 1;
  }
}

int computeChild(unsigned int threadsCount, int i) {
  int index = 0;
  int levelcount = threadsCount;
  int temp;

  if (i < 8 * levelcount)
    return -1;

  while ((index + 8 * levelcount) <= i) {
    temp = levelcount;
    index += 8 * levelcount;
    levelcount = (levelcount + 1) / 2;
  }
  int offset = i - index;

  return (index - 8 * temp) + 2 * offset;
}

int computeRIndex(unsigned int j, const global float* cones) {
  int rindex = 0;
  for (int i = 0; i < j; i += 8) {
    rindex += cones[hook(3, i + 7)];
  }
  return rindex;
}

kernel void IntersectionR(const global float* vertex, const global float* dir, const global float* o, const global float* cones, const global float* bounds, global float* tHit, global int* index,

                          local int* stack, int count, int size, int chunk, int height, unsigned int threadsCount) {
  int iGID = get_global_id(0);
  int iLID = get_local_id(0);

  if (iGID >= size)
    return;

  float3 e1, e2;

  float3 v1, v2, v3;
  v1 = (float3)(vertex[hook(0, 9 * iGID)], vertex[hook(0, 9 * iGID + 1)], vertex[hook(0, 9 * iGID + 2)]);
  v2 = (float3)(vertex[hook(0, 9 * iGID + 3)], vertex[hook(0, 9 * iGID + 4)], vertex[hook(0, 9 * iGID + 5)]);
  v3 = (float3)(vertex[hook(0, 9 * iGID + 6)], vertex[hook(0, 9 * iGID + 7)], vertex[hook(0, 9 * iGID + 8)]);
  e1 = v2 - v1;
  e2 = v3 - v1;

  float3 center;
  float radius;

  center = (v1 + v2 + v3) / 3;
  radius = length(v1 - center);

  float3 a, x;
  float fi;

  unsigned int levelcount = threadsCount;
  unsigned int num = 0;
  unsigned int lastlevelnum = 0;

  for (int i = 1; i < height; i++) {
    lastlevelnum = levelcount;
    num += levelcount;
    levelcount = (levelcount + 1) / 2;
  }

  int SPindex = 0;
  unsigned int begin, rindex;
  int i = 0;
  int child;
  float len;

  begin = 8 * num;
  for (int j = 0; j < levelcount; j++) {
    a = (float3)(cones[hook(3, begin + 8 * j)], cones[hook(3, begin + 8 * j + 1)], cones[hook(3, begin + 8 * j + 2)]);
    x = (float3)(cones[hook(3, begin + 8 * j + 3)], cones[hook(3, begin + 8 * j + 4)], cones[hook(3, begin + 8 * j + 5)]);
    fi = cones[hook(3, begin + 8 * j + 6)];

    len = length(center - a);
    if (acos(dot((center - a) / len, x)) - asin(radius / len) < fi) {
      stack[hook(7, iLID * (height) + SPindex++)] = begin - 8 * lastlevelnum + 16 * j;
      while (SPindex > 0) {
        --SPindex;
        i = stack[hook(7, iLID * (height) + SPindex)];
        a = (float3)(cones[hook(3, i)], cones[hook(3, i + 1)], cones[hook(3, i + 2)]);
        x = (float3)(cones[hook(3, i + 3)], cones[hook(3, i + 4)], cones[hook(3, i + 5)]);
        fi = cones[hook(3, i + 6)];
        len = length(center - a);
        if (len < 0.000002f || acos(dot((center - a) / len, x)) - asin(radius / len) < fi) {
          child = computeChild(threadsCount, i);

          if (child < 0) {
            rindex = computeRIndex(i, cones);
            intersectAllLeaves(dir, o, bounds, index, tHit, v1, v2, v3, e1, e2, cones[hook(3, i + 7)], rindex

            );
          } else {
            stack[hook(7, iLID * (height) + SPindex++)] = child;
          }
        }
        a = (float3)(cones[hook(3, i + 8)], cones[hook(3, i + 9)], cones[hook(3, i + 10)]);
        x = (float3)(cones[hook(3, i + 11)], cones[hook(3, i + 12)], cones[hook(3, i + 13)]);
        fi = cones[hook(3, i + 14)];
        if (len < 0.000002f || acos(dot((center - a) / len, x)) - asin(radius / len) < fi) {
          child = computeChild(threadsCount, i + 8);

          if (child < 0) {
            rindex = computeRIndex(i + 8, cones);
            intersectAllLeaves(dir, o, bounds, index, tHit, v1, v2, v3, e1, e2, cones[hook(3, i + 15)], rindex

            );
          } else {
            stack[hook(7, iLID * (height) + SPindex++)] = child;
          }
        }
      }
    }
  }
}