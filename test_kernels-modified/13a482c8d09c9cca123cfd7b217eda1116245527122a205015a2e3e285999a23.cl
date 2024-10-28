//{"force":2,"num":0,"pos":1,"pos_shared":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float3 atomicForceSR(float3 dp) {
  float r2 = dot(dp, dp);
  if (r2 > 3.24)
    return (float3)(0.0f, 0.0f, 0.0f);
  float ir2 = 1 / (r2 + 1.0e-8);
  float fr = (0.7 - ir2) * (3.24 - r2);
  return dp * fr;
}

float3 atomicForceLJ(float3 dp, float C6, float C12) {
  float ir2 = 1 / (dot(dp, dp) + 1.0e-8);
  float ir6 = ir2 * ir2 * ir2;
  float fr = (6 * C6 * ir6 - 12 * C12 * ir6 * ir6) * ir2;
  return dp * fr;
}

float3 atomicForceR24(float3 dp, float C2, float C4) {
  float ir2 = 1 / (dot(dp, dp) + 1.0e-8);
  float fr = C2 * ir2 - C4 * ir2 * ir2;
  return dp * fr;
}

float3 atomicForceCoulomb(float3 dp, float kQQ) {
  float ir2 = 1 / (dot(dp, dp) + 1.0e-8);
  float ir = sqrt(ir2);
  float fr = ir * ir2 * kQQ;
  return dp * fr;
}

float3 atomicForceLJQ(float3 dp, float3 coefs) {
  float ir2 = 1 / (dot(dp, dp) + 1.0e-8);
  float ir = sqrt(ir2);
  float ir2_ = ir2 * coefs.x * coefs.x;
  float ir6 = ir2_ * ir2_ * ir2_;
  float fr = ((1 - ir6) * ir6 * 12 * coefs.y + ir * coefs.z * -14.3996448915f) * ir2;
  return dp * fr;
}

float3 atomicForceSpring(float3 dp, float k) {
  return dp * k;
}

kernel void NBody_force(unsigned int num, global float4* pos, global float4* force) {
  const int iG = get_global_id(0);
  const int iL = get_local_id(0);
  const int nL = get_local_size(0);
  local float4 pos_shared[64];
  float3 p = pos[hook(1, iG)].xyz;
  float3 f = (float3)(0.0f, 0.0f, 0.0f);
  for (int i0 = 0; i0 < num; i0 += nL) {
    pos_shared[hook(3, iL)] = pos[hook(1, i0 + iL)];
    barrier(0x01);
    for (int j = 0; j < nL; j++) {
      float3 pj = pos_shared[hook(3, j)].xyz;
      f += atomicForceR24(pj - p, 1.0f, 3.0f);
    }
    barrier(0x01);
  }
  force[hook(2, iG)] = (float4)(f, 0.0f);
}