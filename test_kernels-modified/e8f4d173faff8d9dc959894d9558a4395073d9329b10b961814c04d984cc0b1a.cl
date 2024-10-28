//{"bounds":3,"count":9,"dir":1,"dp":7,"index":8,"o":2,"size":10,"tHit":5,"tutv":6,"uvs":4,"vertex":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void IntersectionR(const global float* vertex, const global float* dir, const global float* o, const global float* bounds, const global float* uvs, global float* tHit, global float* tutv, global float* dp, global int* index, int count, int size) {
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

    if (tHit[hook(5, i)] != (__builtin_inff()) && tHit[hook(5, i)] != __builtin_astype((2147483647), float) && t > tHit[hook(5, i)])
      continue;

    tHit[hook(5, i)] = t;
    index[hook(8, i)] = iGID;

    float du1 = uvs[hook(4, 6 * iGID)] - uvs[hook(4, 6 * iGID + 4)];
    float du2 = uvs[hook(4, 6 * iGID + 2)] - uvs[hook(4, 6 * iGID + 4)];
    float dv1 = uvs[hook(4, 6 * iGID + 1)] - uvs[hook(4, 6 * iGID + 5)];
    float dv2 = uvs[hook(4, 6 * iGID + 3)] - uvs[hook(4, 6 * iGID + 5)];
    float4 dp1 = v1 - v3;
    float4 dp2 = v2 - v3;
    float determinant = du1 * dv2 - dv1 * du2;
    if (determinant == 0.f) {
      float4 temp = normalize(cross(e2, e1));
      if (fabs(temp.x) > fabs(temp.y)) {
        float invLen = rsqrt(temp.x * temp.x + temp.z * temp.z);
        dp[hook(7, 6 * i)] = -temp.z * invLen;
        dp[hook(7, 6 * i + 1)] = 0.f;
        dp[hook(7, 6 * i + 2)] = temp.x * invLen;
      } else {
        float invLen = rsqrt(temp.y * temp.y + temp.z * temp.z);
        dp[hook(7, 6 * i)] = 0.f;
        dp[hook(7, 6 * i + 1)] = temp.z * invLen;
        dp[hook(7, 6 * i + 2)] = -temp.y * invLen;
      }
      float4 help = cross(temp, (float4)(dp[hook(7, 6 * i)], dp[hook(7, 6 * i + 1)], dp[hook(7, 6 * i + 2)], 0));
      dp[hook(7, 6 * i + 3)] = help.x;
      dp[hook(7, 6 * i + 4)] = help.y;
      dp[hook(7, 6 * i + 5)] = help.z;
    } else {
      float invdet = 1.f / determinant;
      float4 help = (dv2 * dp1 - dv1 * dp2) * invdet;
      dp[hook(7, 6 * i)] = help.x;
      dp[hook(7, 6 * i + 1)] = help.y;
      dp[hook(7, 6 * i + 2)] = help.z;
      help = (-du2 * dp1 + du1 * dp2) * invdet;
      dp[hook(7, 6 * i + 3)] = help.x;
      dp[hook(7, 6 * i + 4)] = help.y;
      dp[hook(7, 6 * i + 5)] = help.z;
    }

    float b0 = 1 - b1 - b2;
    tutv[hook(6, 2 * i)] = b0 * uvs[hook(4, 6 * iGID)] + b1 * uvs[hook(4, 6 * iGID + 2)] + b2 * uvs[hook(4, 6 * iGID + 4)];
    tutv[hook(6, 2 * i + 1)] = b0 * uvs[hook(4, 6 * iGID + 1)] + b1 * uvs[hook(4, 6 * iGID + 3)] + b2 * uvs[hook(4, 6 * iGID + 5)];
  }
}