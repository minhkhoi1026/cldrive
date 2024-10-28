//{"bounds":8,"changed":10,"count":7,"dir":1,"dp":6,"index":3,"o":2,"tHit":9,"tutv":5,"uvs":4,"vertex":0}
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
    if (t < bounds[hook(8, 2 * rindex + i * 2)])
      continue;

    tHit[hook(9, rindex + i)] = '1';
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
    if (t < bounds[hook(8, 2 * rindex + i * 2)])
      continue;

    if (t > tHit[hook(9, rindex + i)])
      continue;
    tHit[hook(9, rindex + i)] = t;
    index[hook(3, rindex + i)] = get_global_id(0);
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
    if (t < bounds[hook(8, 2 * rindex + i * 2)])
      continue;

    if (t > tHit[hook(9, rindex + i)])
      continue;
    tHit[hook(9, rindex + i)] = t;
    index[hook(3, rindex + i)] = get_global_id(0);
    changed[hook(10, get_global_id(0))] = 1;
  }
}

kernel void computeDpTuTv(const global float* vertex, const global float* dir, const global float* o, const global int* index, const global float* uvs, global float* tutv, global float* dp, int count) {
  int iGID = get_global_id(0);
  if (iGID >= count)
    return;
  int i = index[hook(3, iGID)];
  if (i == 0)
    return;

  float3 rayd, rayo, v1, v2, v3, e1, e2;
  float b1, b2, invDivisor;

  rayd = (float3)(dir[hook(1, 3 * iGID)], dir[hook(1, 3 * iGID + 1)], dir[hook(1, 3 * iGID + 2)]);
  rayo = (float3)(o[hook(2, 3 * iGID)], o[hook(2, 3 * iGID + 1)], o[hook(2, 3 * iGID + 2)]);

  v1 = (float3)(vertex[hook(0, 9 * i)], vertex[hook(0, 9 * i + 1)], vertex[hook(0, 9 * i + 2)]);
  v2 = (float3)(vertex[hook(0, 9 * i + 3)], vertex[hook(0, 9 * i + 4)], vertex[hook(0, 9 * i + 5)]);
  v3 = (float3)(vertex[hook(0, 9 * i + 6)], vertex[hook(0, 9 * i + 7)], vertex[hook(0, 9 * i + 8)]);
  e1 = v2 - v1;
  e2 = v3 - v1;

  float3 s1 = cross(rayd, e2);
  float divisor = dot(s1, e1);
  invDivisor = 1.0f / divisor;

  float3 d = rayo - v1;
  b1 = dot(d, s1) * invDivisor;

  float3 s2 = cross(d, e1);
  b2 = dot(rayd, s2) * invDivisor;

  float du1 = uvs[hook(4, 6 * i)] - uvs[hook(4, 6 * i + 4)];
  float du2 = uvs[hook(4, 6 * i + 2)] - uvs[hook(4, 6 * i + 4)];
  float dv1 = uvs[hook(4, 6 * i + 1)] - uvs[hook(4, 6 * i + 5)];
  float dv2 = uvs[hook(4, 6 * i + 3)] - uvs[hook(4, 6 * i + 5)];
  float3 dp1 = v1 - v3;
  float3 dp2 = v2 - v3;

  float determinant = du1 * dv2 - dv1 * du2;

  if (determinant == 0.f) {
    float3 temp = normalize(cross(e2, e1));
    if (fabs(temp.x) > fabs(temp.y)) {
      float invLen = rsqrt(temp.x * temp.x + temp.z * temp.z);
      dp[hook(6, 6 * iGID)] = -temp.z * invLen;
      dp[hook(6, 6 * iGID + 1)] = 0.f;
      dp[hook(6, 6 * iGID + 2)] = temp.x * invLen;
    } else {
      float invLen = rsqrt(temp.y * temp.y + temp.z * temp.z);
      dp[hook(6, 6 * iGID)] = 0.f;
      dp[hook(6, 6 * iGID + 1)] = temp.z * invLen;
      dp[hook(6, 6 * iGID + 2)] = -temp.y * invLen;
    }
    float3 help = cross(temp, (float3)(dp[hook(6, 6 * iGID)], dp[hook(6, 6 * iGID + 1)], dp[hook(6, 6 * iGID + 2)]));
    dp[hook(6, 6 * iGID + 3)] = help.x;
    dp[hook(6, 6 * iGID + 4)] = help.y;
    dp[hook(6, 6 * iGID + 5)] = help.z;
  } else {
    float invdet = 1.f / determinant;
    float3 help = (dv2 * dp1 - dv1 * dp2) * invdet;

    dp[hook(6, 6 * iGID)] = help.x;
    dp[hook(6, 6 * iGID + 1)] = help.y;
    dp[hook(6, 6 * iGID + 2)] = help.z;
    help = (-du2 * dp1 + du1 * dp2) * invdet;
    dp[hook(6, 6 * iGID + 3)] = help.x;
    dp[hook(6, 6 * iGID + 4)] = help.y;
    dp[hook(6, 6 * iGID + 5)] = help.z;
  }

  float b0 = 1 - b1 - b2;
  tutv[hook(5, 2 * iGID)] = b0 * uvs[hook(4, 6 * i)] + b1 * uvs[hook(4, 6 * i + 2)] + b2 * uvs[hook(4, 6 * i + 4)];
  tutv[hook(5, 2 * iGID + 1)] = b0 * uvs[hook(4, 6 * i + 1)] + b1 * uvs[hook(4, 6 * i + 3)] + b2 * uvs[hook(4, 6 * i + 5)];
}