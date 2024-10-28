//{"Bx":9,"By":10,"Bz":11,"Ip_gl":13,"Is_gl":12,"ag":8,"ddphi":5,"ddpsi":6,"gamma":3,"jend":0,"lUnd":2,"nwt":1,"tg":7,"w":4}
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

  k1Beta = rkStep * f_beta(Bx[hook(9, iZeroStep)], By[hook(10, iZeroStep)], Bz[hook(11, iZeroStep)], emcg, beta);
  k2Beta = rkStep * f_beta(Bx[hook(9, iHalfStep)], By[hook(10, iHalfStep)], Bz[hook(11, iHalfStep)], emcg, beta + HALF * k1Beta);
  k3Beta = rkStep * f_beta(Bx[hook(9, iHalfStep)], By[hook(10, iHalfStep)], Bz[hook(11, iHalfStep)], emcg, beta + HALF * k2Beta);
  k4Beta = rkStep * f_beta(Bx[hook(9, iFullStep)], By[hook(10, iFullStep)], Bz[hook(11, iFullStep)], emcg, beta + k3Beta);
  return beta + (k1Beta + TWO * k2Beta + TWO * k3Beta + k4Beta) / SIX;
}

float8 next_traj_rk(float2 beta, float3 traj, int iZeroStep, int iHalfStep, int iFullStep, float rkStep, float emcg, float revgamma, global float* Bx, global float* By, global float* Bz) {
  float2 k1Beta, k2Beta, k3Beta, k4Beta;
  float3 k1Traj, k2Traj, k3Traj, k4Traj;

  k1Beta = rkStep * f_beta(Bx[hook(9, iZeroStep)], By[hook(10, iZeroStep)], Bz[hook(11, iZeroStep)], emcg, beta);
  k1Traj = rkStep * f_traj(revgamma, beta);

  k2Beta = rkStep * f_beta(Bx[hook(9, iHalfStep)], By[hook(10, iHalfStep)], Bz[hook(11, iHalfStep)], emcg, beta + HALF * k1Beta);
  k2Traj = rkStep * f_traj(revgamma, beta + HALF * k1Beta);

  k3Beta = rkStep * f_beta(Bx[hook(9, iHalfStep)], By[hook(10, iHalfStep)], Bz[hook(11, iHalfStep)], emcg, beta + HALF * k2Beta);
  k3Traj = rkStep * f_traj(revgamma, beta + HALF * k2Beta);

  k4Beta = rkStep * f_beta(Bx[hook(9, iFullStep)], By[hook(10, iFullStep)], Bz[hook(11, iFullStep)], emcg, beta + k3Beta);
  k4Traj = rkStep * f_traj(revgamma, beta + k3Beta);

  return (float8)(beta + (k1Beta + TWO * k2Beta + TWO * k3Beta + k4Beta) / SIX, traj + (k1Traj + TWO * k2Traj + TWO * k3Traj + k4Traj) / SIX, 0., 0., 0.);
}

kernel void undulator_custom(const int jend, const int nwt, const float lUnd, global float* gamma, global float* w, global float* ddphi, global float* ddpsi, global float* tg, global float* ag, global float* Bx, global float* By, global float* Bz, global float2* Is_gl, global float2* Ip_gl) {
  unsigned int ii = get_global_id(0);
  int j, k, jb;
  int iBase, iZeroStep, iHalfStep, iFullStep;

  float ucos, sinucos, cosucos, rkStep, wu_int, betam_int, krel;
  float revg = 1. / gamma[hook(3, ii)];
  float revg2 = revg * revg;
  float emcg = lUnd * SIE0 / SIM0 / C * revg / PI2;
  float revgamma = 1. - revg2;
  float8 betaTraj;
  float2 eucos;
  float2 Is = zero2;
  float2 Ip = zero2;
  float2 beta, beta0;
  float3 traj, n, traj0, betaC, betaP, nnb;

  n.x = ddphi[hook(5, ii)];
  n.y = ddpsi[hook(6, ii)];
  n.z = 1. - HALF * (n.x * n.x + n.y * n.y);

  beta = zero2;
  beta0 = zero2;
  betam_int = 0;

  for (j = 1; j < jend; j++) {
    iBase = 2 * (j - 1) * nwt;
    rkStep = (tg[hook(7, j)] - tg[hook(7, j - 1)]) / nwt;
    for (k = 0; k < nwt; k++) {
      iZeroStep = iBase + 2 * k;
      iHalfStep = iBase + 2 * k + 1;
      iFullStep = iBase + 2 * (k + 1);
      beta = next_beta_rk(beta, iZeroStep, iHalfStep, iFullStep, rkStep, emcg, Bx, By, Bz);
      beta0 += beta * rkStep;
    }
  }

  mem_fence(0x01);
  beta0 /= -(tg[hook(7, jend - 1)] - tg[hook(7, 0)]);
  beta = beta0;
  traj = (float3)(0., 0., 0.);
  traj0 = (float3)(0., 0., 0.);

  for (j = 1; j < jend; j++) {
    iBase = (j - 1) * 2 * nwt;
    rkStep = (tg[hook(7, j)] - tg[hook(7, j - 1)]) / nwt;
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
  traj0 /= -(tg[hook(7, jend - 1)] - tg[hook(7, 0)]);
  beta = beta0;
  traj = traj0;
  betam_int /= (tg[hook(7, jend - 1)] - tg[hook(7, 0)]);
  wu_int = PI2 * C * betam_int / lUnd / E2W;

  for (j = 1; j < jend; j++) {
    iBase = 2 * (j - 1) * nwt;
    rkStep = (tg[hook(7, j)] - tg[hook(7, j - 1)]) / nwt;
    for (k = 0; k < nwt; k++) {
      iZeroStep = iBase + 2 * k;
      iHalfStep = iBase + 2 * k + 1;
      iFullStep = iBase + 2 * (k + 1);
      betaTraj = next_traj_rk(beta, traj, iZeroStep, iHalfStep, iFullStep, rkStep, emcg, revgamma, Bx, By, Bz);
      beta = betaTraj.s01;
      traj = betaTraj.s234;
    }

    mem_fence(0x01);
    ucos = w[hook(4, ii)] / wu_int * (tg[hook(7, j)] - dot(n, traj));
    sinucos = sincos(ucos, &cosucos);
    eucos.x = cosucos;
    eucos.y = sinucos;

    jb = 2 * j * nwt;

    betaC.x = beta.x;
    betaC.y = beta.y;
    betaC.z = 1 - HALF * (revg2 + betaC.x * betaC.x + betaC.y * betaC.y);

    betaP.x = wu_int * emcg * (betaC.y * Bz[hook(11, jb)] - By[hook(10, jb)]);
    betaP.y = wu_int * emcg * (-betaC.x * Bz[hook(11, jb)] + Bx[hook(9, jb)]);
    betaP.z = wu_int * emcg * (betaC.x * By[hook(10, jb)] - betaC.y * Bx[hook(9, jb)]);

    if (isHiPrecision) {
      krel = 1. - dot(n, betaC);
      nnb = cross(n, cross((n - betaC), betaP)) / (krel * krel);
    } else
      nnb = (n - betaC) * w[hook(4, ii)];

    Is += (ag[hook(8, j)] * nnb.x) * eucos;
    Ip += (ag[hook(8, j)] * nnb.y) * eucos;
  }

  mem_fence(0x01);

  Is_gl[hook(12, ii)] = Is;
  Ip_gl[hook(13, ii)] = Ip;
}