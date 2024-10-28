//{"Bx":12,"By":13,"Bz":14,"Ip_gl":21,"Is_gl":20,"L0":5,"R0":6,"ag":11,"betax":15,"betay":16,"ddphi":8,"ddpsi":9,"emcg":2,"gamma2":3,"jend":0,"nwt":1,"tg":10,"trajx":17,"trajy":18,"trajz":19,"w":7,"wu":4}
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

  k1Beta = rkStep * f_beta(Bx[hook(12, iZeroStep)], By[hook(13, iZeroStep)], Bz[hook(14, iZeroStep)], emcg, beta);
  k2Beta = rkStep * f_beta(Bx[hook(12, iHalfStep)], By[hook(13, iHalfStep)], Bz[hook(14, iHalfStep)], emcg, beta + HALF * k1Beta);
  k3Beta = rkStep * f_beta(Bx[hook(12, iHalfStep)], By[hook(13, iHalfStep)], Bz[hook(14, iHalfStep)], emcg, beta + HALF * k2Beta);
  k4Beta = rkStep * f_beta(Bx[hook(12, iFullStep)], By[hook(13, iFullStep)], Bz[hook(14, iFullStep)], emcg, beta + k3Beta);
  return beta + (k1Beta + TWO * k2Beta + TWO * k3Beta + k4Beta) / SIX;
}

float8 next_traj_rk(float2 beta, float3 traj, int iZeroStep, int iHalfStep, int iFullStep, float rkStep, float emcg, float revgamma, global float* Bx, global float* By, global float* Bz) {
  float2 k1Beta, k2Beta, k3Beta, k4Beta;
  float3 k1Traj, k2Traj, k3Traj, k4Traj;

  k1Beta = rkStep * f_beta(Bx[hook(12, iZeroStep)], By[hook(13, iZeroStep)], Bz[hook(14, iZeroStep)], emcg, beta);
  k1Traj = rkStep * f_traj(revgamma, beta);

  k2Beta = rkStep * f_beta(Bx[hook(12, iHalfStep)], By[hook(13, iHalfStep)], Bz[hook(14, iHalfStep)], emcg, beta + HALF * k1Beta);
  k2Traj = rkStep * f_traj(revgamma, beta + HALF * k1Beta);

  k3Beta = rkStep * f_beta(Bx[hook(12, iHalfStep)], By[hook(13, iHalfStep)], Bz[hook(14, iHalfStep)], emcg, beta + HALF * k2Beta);
  k3Traj = rkStep * f_traj(revgamma, beta + HALF * k2Beta);

  k4Beta = rkStep * f_beta(Bx[hook(12, iFullStep)], By[hook(13, iFullStep)], Bz[hook(14, iFullStep)], emcg, beta + k3Beta);
  k4Traj = rkStep * f_traj(revgamma, beta + k3Beta);

  return (float8)(beta + (k1Beta + TWO * k2Beta + TWO * k3Beta + k4Beta) / SIX, traj + (k1Traj + TWO * k2Traj + TWO * k3Traj + k4Traj) / SIX, 0., 0., 0.);
}

kernel void undulator_custom_filament(const int jend, const int nwt, const float emcg, const float gamma2, const float wu, const float L0, const float R0, global float* w, global float* ddphi, global float* ddpsi, global float* tg, global float* ag, global float* Bx, global float* By, global float* Bz, global float* betax, global float* betay, global float* trajx, global float* trajy, global float* trajz, global float2* Is_gl, global float2* Ip_gl) {
  unsigned int ii = get_global_id(0);
  int j, jb;

  float ucos, sinucos, cosucos, wR0, krel;
  float revg2 = 1. / gamma2;

  float2 eucos;
  float2 Is = (float2)(0., 0.);
  float2 Ip = (float2)(0., 0.);

  float3 traj, n, r0, betaC, betaP, nnb;

  n.x = ddphi[hook(8, ii)];
  n.y = ddpsi[hook(9, ii)];
  n.z = 1. - HALF * (n.x * n.x + n.y * n.y);

  if (R0 > 0) {
    wR0 = R0 * PI2 / L0;
    r0.x = wR0 * tan(ddphi[hook(8, ii)]);
    r0.y = wR0 * tan(ddpsi[hook(9, ii)]);
    r0.z = wR0 * cos(sqrt(ddphi[hook(8, ii)] * ddphi[hook(8, ii)] + ddpsi[hook(9, ii)] * ddpsi[hook(9, ii)]));
  }

  for (j = 1; j < jend; j++) {
    traj.x = trajx[hook(17, j)];
    traj.y = trajy[hook(18, j)];
    traj.z = trajz[hook(19, j)];
    if (R0 > 0) {
      ucos = w[hook(7, ii)] / wu * (tg[hook(10, j)] + length(r0 - traj));
    } else {
      ucos = w[hook(7, ii)] / wu * (tg[hook(10, j)] - dot(n, traj));
    }
    sinucos = sincos(ucos, &cosucos);
    eucos.x = cosucos;
    eucos.y = sinucos;

    jb = 2 * j * nwt;

    betaC.x = betax[hook(15, j)];
    betaC.y = betay[hook(16, j)];
    betaC.z = 1 - HALF * (revg2 + betaC.x * betaC.x + betaC.y * betaC.y);

    betaP.x = wu * emcg * (betaC.y * Bz[hook(14, jb)] - By[hook(13, jb)]);
    betaP.y = wu * emcg * (-betaC.x * Bz[hook(14, jb)] + Bx[hook(12, jb)]);
    betaP.z = wu * emcg * (betaC.x * By[hook(13, jb)] - betaC.y * Bx[hook(12, jb)]);

    if (isHiPrecision) {
      krel = 1. - dot(n, betaC);
      nnb = cross(n, cross((n - betaC), betaP)) / (krel * krel);
    } else
      nnb = (n - betaC) * w[hook(7, ii)];

    Is += (ag[hook(11, j)] * nnb.x) * eucos;
    Ip += (ag[hook(11, j)] * nnb.y) * eucos;
  }

  mem_fence(0x01);
  Is_gl[hook(20, ii)] = Is;
  Ip_gl[hook(21, ii)] = Ip;
}