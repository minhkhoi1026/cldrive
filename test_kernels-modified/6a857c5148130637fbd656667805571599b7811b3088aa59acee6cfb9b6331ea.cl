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

  for (i = 0; i < n; i++) {
    float4 p2 = ppo[hook(5, i + 0)];

    float4 dp = p2 - p0;
    float invr = rsqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
    a0 += (p2.w * invr * invr * invr) * dp;
    dp = p2 - p1;
    invr = rsqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
    a1 += (p2.w * invr * invr * invr) * dp;
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