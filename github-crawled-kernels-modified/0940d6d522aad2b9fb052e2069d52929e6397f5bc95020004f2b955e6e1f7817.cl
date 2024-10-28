//{"Bx":5,"By":6,"Bz":7,"betax":8,"betay":9,"betazav":10,"emcg":2,"gamma":3,"jend":0,"nwt":1,"tg":4,"trajx":11,"trajy":12,"trajz":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float QUAR = 0.25;
constant float HALF = 0.5;
constant float TWO = 2.;
constant float SIX = 6.;
constant bool isHiPrecision = sizeof(TWO) == 8;
constant float2 zero2 = (float2)(0, 0);
constant float PI2 = (float)6.283185307179586476925286766559;
constant float E2W = 1.51926751475e15;
constant float C = 2.99792458e11;
constant float SIE0 = 1.602176565e-19;
constant float SIM0 = 9.10938291e-31;
float2 f_beta(float Bx, float By, float Bz, float emcg, float2 beta) {
  return emcg * (float2)(beta.y * Bz - By, Bx - beta.x * Bz);
}

float3 f_traj(float revgamma, float2 beta) {
  return (float3)(beta.x, beta.y, sqrt(revgamma - beta.x * beta.x - beta.y * beta.y));
}

float2 next_beta_rk(float2 beta, int iZeroStep, int iHalfStep, int iFullStep, float rkStep, float emcg, global float* Bx, global float* By, global float* Bz) {
  float2 k1Beta, k2Beta, k3Beta, k4Beta;

  k1Beta = rkStep * f_beta(Bx[hook(5, iZeroStep)], By[hook(6, iZeroStep)], Bz[hook(7, iZeroStep)], emcg, beta);
  k2Beta = rkStep * f_beta(Bx[hook(5, iHalfStep)], By[hook(6, iHalfStep)], Bz[hook(7, iHalfStep)], emcg, beta + HALF * k1Beta);
  k3Beta = rkStep * f_beta(Bx[hook(5, iHalfStep)], By[hook(6, iHalfStep)], Bz[hook(7, iHalfStep)], emcg, beta + HALF * k2Beta);
  k4Beta = rkStep * f_beta(Bx[hook(5, iFullStep)], By[hook(6, iFullStep)], Bz[hook(7, iFullStep)], emcg, beta + k3Beta);
  return beta + (k1Beta + TWO * k2Beta + TWO * k3Beta + k4Beta) / SIX;
}

float8 next_traj_rk(float2 beta, float3 traj, int iZeroStep, int iHalfStep, int iFullStep, float rkStep, float emcg, float revgamma, global float* Bx, global float* By, global float* Bz) {
  float2 k1Beta, k2Beta, k3Beta, k4Beta;
  float3 k1Traj, k2Traj, k3Traj, k4Traj;

  k1Beta = rkStep * f_beta(Bx[hook(5, iZeroStep)], By[hook(6, iZeroStep)], Bz[hook(7, iZeroStep)], emcg, beta);
  k1Traj = rkStep * f_traj(revgamma, beta);

  k2Beta = rkStep * f_beta(Bx[hook(5, iHalfStep)], By[hook(6, iHalfStep)], Bz[hook(7, iHalfStep)], emcg, beta + HALF * k1Beta);
  k2Traj = rkStep * f_traj(revgamma, beta + HALF * k1Beta);

  k3Beta = rkStep * f_beta(Bx[hook(5, iHalfStep)], By[hook(6, iHalfStep)], Bz[hook(7, iHalfStep)], emcg, beta + HALF * k2Beta);
  k3Traj = rkStep * f_traj(revgamma, beta + HALF * k2Beta);

  k4Beta = rkStep * f_beta(Bx[hook(5, iFullStep)], By[hook(6, iFullStep)], Bz[hook(7, iFullStep)], emcg, beta + k3Beta);
  k4Traj = rkStep * f_traj(revgamma, beta + k3Beta);

  return (float8)(beta + (k1Beta + TWO * k2Beta + TWO * k3Beta + k4Beta) / SIX, traj + (k1Traj + TWO * k2Traj + TWO * k3Traj + k4Traj) / SIX, 0., 0., 0.);
}

kernel void get_trajectory(const int jend, const int nwt, const float emcg, const float gamma, global float* tg, global float* Bx, global float* By, global float* Bz, global float* betax, global float* betay, global float* betazav, global float* trajx, global float* trajy, global float* trajz) {
  int j, k;
  int iBase, iZeroStep, iHalfStep, iFullStep;

  float rkStep;
  float revgamma = 1. - 1. / gamma / gamma;
  float betam_int = 0;
  float2 beta, beta0;
  float3 traj, traj0;
  float8 betaTraj;

  beta = zero2;
  beta0 = zero2;

  for (j = 1; j < jend; j++) {
    iBase = (j - 1) * 2 * nwt;
    rkStep = (tg[hook(4, j)] - tg[hook(4, j - 1)]) / nwt;
    for (k = 0; k < nwt; k++) {
      iZeroStep = iBase + 2 * k;
      iHalfStep = iBase + 2 * k + 1;
      iFullStep = iBase + 2 * (k + 1);
      beta = next_beta_rk(beta, iZeroStep, iHalfStep, iFullStep, rkStep, emcg, Bx, By, Bz);
      beta0 += beta * rkStep;
    }
  }
  mem_fence(0x01);
  beta0 /= -(tg[hook(4, jend - 1)] - tg[hook(4, 0)]);
  beta = beta0;
  traj = (float3)(0., 0., 0.);
  traj0 = (float3)(0., 0., 0.);

  for (j = 1; j < jend; j++) {
    iBase = 2 * (j - 1) * nwt;
    rkStep = (tg[hook(4, j)] - tg[hook(4, j - 1)]) / nwt;
    for (k = 0; k < nwt; k++) {
      iZeroStep = iBase + 2 * k;
      iHalfStep = iBase + 2 * k + 1;
      iFullStep = iBase + 2 * (k + 1);
      betaTraj = next_traj_rk(beta, traj, iZeroStep, iHalfStep, iFullStep, rkStep, emcg, revgamma, Bx, By, Bz);
      beta = betaTraj.s01;
      traj = betaTraj.s234;
      traj0 += traj * rkStep;
      betam_int += rkStep * sqrt(revgamma - beta.x * beta.x - beta.y * beta.y);
    }
  }
  mem_fence(0x01);
  traj0 /= -(tg[hook(4, jend - 1)] - tg[hook(4, 0)]);
  beta = beta0;
  traj = traj0;
  betam_int /= tg[hook(4, jend - 1)] - tg[hook(4, 0)];

  for (j = 1; j < jend; j++) {
    iBase = 2 * (j - 1) * nwt;
    rkStep = (tg[hook(4, j)] - tg[hook(4, j - 1)]) / nwt;
    for (k = 0; k < nwt; k++) {
      iZeroStep = iBase + 2 * k;
      iHalfStep = iBase + 2 * k + 1;
      iFullStep = iBase + 2 * (k + 1);
      betaTraj = next_traj_rk(beta, traj, iZeroStep, iHalfStep, iFullStep, rkStep, emcg, revgamma, Bx, By, Bz);
      beta = betaTraj.s01;
      traj = betaTraj.s234;
    }

    betax[hook(8, j)] = beta.x;
    betay[hook(9, j)] = beta.y;
    betazav[hook(10, j)] = betam_int;
    trajx[hook(11, j)] = traj.x;
    trajy[hook(12, j)] = traj.y;
    trajz[hook(13, j)] = traj.z;
  }

  barrier(0x01);
}