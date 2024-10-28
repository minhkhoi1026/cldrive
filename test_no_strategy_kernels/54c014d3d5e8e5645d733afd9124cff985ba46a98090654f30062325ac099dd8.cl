//{"dt":1,"eps":2,"n":0,"pblock":6,"pp":3,"ppo":5,"vv":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nbody_kern(int n, float dt, float eps, global float4* pp, global float4* vv, global float4* ppo, local float4* pblock) {
  const float4 zero4 = (float4){0.0f, 0.0f, 0.0f, 0.0f};
  const float4 invtwo4 = (float4){0.5f, 0.5f, 0.5f, 0.5f};
  const float4 dt4 = (float4){dt, dt, dt, 0.0f};

  int gti = get_global_id(0);

  int ti = get_local_id(0);

  int nt = get_local_size(0);

  int nb = n / nt;

  float4 p0 = ppo[hook(5, gti + 0)];

  float4 a0 = zero4;

  int ib, i;

  for (ib = 0; ib < nb; ib++) {
    prefetch(ppo, 64);

    int gci = ib * nt + ti;

    pblock[hook(6, ti)] = ppo[hook(5, gci)];

    barrier(0x01);

    for (i = 0; i < nt; i += 8) {
      float4 p2 = pblock[hook(6, i)];
      float4 p3 = pblock[hook(6, i + 1)];
      float4 p4 = pblock[hook(6, i + 2)];
      float4 p5 = pblock[hook(6, i + 3)];

      float4 p6 = pblock[hook(6, i + 4)];
      float4 p7 = pblock[hook(6, i + 5)];
      float4 p8 = pblock[hook(6, i + 6)];
      float4 p9 = pblock[hook(6, i + 7)];

      float4 dp = p2 - p0;
      float invr = 1 / sqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
      a0 += (p2.w * invr * invr * invr) * dp;

      dp = p3 - p0;
      invr = 1 / sqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
      a0 += (p2.w * invr * invr * invr) * dp;

      dp = p4 - p0;
      invr = 1 / sqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
      a0 += (p2.w * invr * invr * invr) * dp;

      dp = p5 - p0;
      invr = 1 / sqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
      a0 += (p2.w * invr * invr * invr) * dp;

      dp = p6 - p0;
      invr = 1 / sqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
      a0 += (p2.w * invr * invr * invr) * dp;

      dp = p7 - p0;
      invr = 1 / sqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
      a0 += (p2.w * invr * invr * invr) * dp;

      dp = p8 - p0;
      invr = 1 / sqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
      a0 += (p2.w * invr * invr * invr) * dp;

      dp = p9 - p0;
      invr = 1 / sqrt(dp.x * dp.x + dp.y * dp.y + dp.z * dp.z + eps);
      a0 += (p2.w * invr * invr * invr) * dp;
    }

    barrier(0x01);
  }

  float4 v0 = vv[hook(4, gti + 0)];
  p0 += dt4 * v0 + invtwo4 * dt4 * dt4 * a0;
  v0 += dt4 * a0;
  pp[hook(3, gti + 0)] = p0;
  vv[hook(4, gti + 0)] = v0;

  return;
}