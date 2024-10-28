//{"dt":1,"eps":2,"n":0,"pp":3,"ppo":5,"vv":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nbody_kern(int n, float dt, float eps, global float4* pp, global float4* vv, global float4* ppo) {
  const float4 zero4 = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  const float4 invtwo4 = (float4)(0.5f, 0.5f, 0.5f, 0.5f);
  const float4 dt4 = (float4)(dt, dt, dt, 0.0f);

  int gti = 2 * get_global_id(0);

  int ti = get_local_id(0);

  float4 p0 = ppo[hook(5, gti + 0)];
  float4 p1 = ppo[hook(5, gti + 1)];

  float4 a0 = zero4;
  float4 a1 = zero4;

  int i;

  n *= 2;

  for (i = 0; i < n; i += 8) {
    float4 p2 = ppo[hook(5, i + 0)];
    float4 p3 = ppo[hook(5, i + 1)];
    float4 p4 = ppo[hook(5, i + 2)];
    float4 p5 = ppo[hook(5, i + 3)];

    float4 p6 = ppo[hook(5, i + 4)];
    float4 p7 = ppo[hook(5, i + 5)];
    float4 p8 = ppo[hook(5, i + 6)];
    float4 p9 = ppo[hook(5, i + 7)];

    float4 dp = p2 - p0;
    float invr = rsqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
    a0 += (p2.w * invr * invr * invr) * dp;
    dp = p2 - p1;
    invr = rsqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
    a1 += (p2.w * invr * invr * invr) * dp;

    dp = p3 - p0;
    invr = rsqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
    a0 += (p3.w * invr * invr * invr) * dp;
    dp = p3 - p1;
    invr = rsqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
    a1 += (p3.w * invr * invr * invr) * dp;

    dp = p4 - p0;
    invr = rsqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
    a0 += (p4.w * invr * invr * invr) * dp;
    dp = p4 - p1;
    invr = rsqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
    a1 += (p4.w * invr * invr * invr) * dp;

    dp = p5 - p0;
    invr = rsqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
    a0 += (p5.w * invr * invr * invr) * dp;
    dp = p5 - p1;
    invr = rsqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
    a1 += (p5.w * invr * invr * invr) * dp;

    dp = p6 - p0;
    invr = rsqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
    a0 += (p6.w * invr * invr * invr) * dp;
    dp = p6 - p1;
    invr = rsqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
    a1 += (p6.w * invr * invr * invr) * dp;

    dp = p7 - p0;
    invr = rsqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
    a0 += (p7.w * invr * invr * invr) * dp;
    dp = p7 - p1;
    invr = rsqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
    a1 += (p7.w * invr * invr * invr) * dp;

    dp = p8 - p0;
    invr = rsqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
    a0 += (p8.w * invr * invr * invr) * dp;
    dp = p8 - p1;
    invr = rsqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
    a1 += (p8.w * invr * invr * invr) * dp;

    dp = p9 - p0;
    invr = rsqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
    a0 += (p9.w * invr * invr * invr) * dp;
    dp = p9 - p1;
    invr = rsqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
    a1 += (p9.w * invr * invr * invr) * dp;
  }

  float4 v0 = vv[hook(4, gti + 0)];
  float4 v1 = vv[hook(4, gti + 1)];
  p0 += dt4 * v0 + invtwo4 * dt4 * dt4 * a0;
  p1 += dt4 * v1 + invtwo4 * dt4 * dt4 * a1;
  v0 += dt4 * a0;
  v1 += dt4 * a1;
  pp[hook(3, gti + 0)] = p0;
  pp[hook(3, gti + 1)] = p1;
  vv[hook(4, gti + 0)] = v0;
  vv[hook(4, gti + 1)] = v1;

  return;
}