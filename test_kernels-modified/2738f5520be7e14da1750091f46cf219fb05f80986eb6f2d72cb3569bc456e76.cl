//{"Ip_gl":14,"Is_gl":13,"Kx":1,"Ky":2,"ag":12,"alpha":0,"ddphi":9,"ddpsi":10,"gamma":5,"jend":4,"phase":3,"tg":11,"w":7,"wu":6,"ww1":8}
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
kernel void undulator_taper(const float alpha, const float Kx, const float Ky, const float phase, const int jend, global float* gamma, global float* wu, global float* w, global float* ww1, global float* ddphi, global float* ddpsi, global float* tg, global float* ag, global float2* Is_gl, global float2* Ip_gl) {
  unsigned int ii = get_global_id(0);
  int j;

  float2 eucos;
  float3 n, nnb, beta, betaP;
  float ucos, sinucos, cosucos, sintg, sin2tg, sin2tgph, costg, sintgph, costgph, krel;
  float2 Is = zero2;
  float2 Ip = zero2;
  float Kx2 = Kx * Kx;
  float Ky2 = Ky * Ky;
  float alphaS = alpha * C / wu[hook(6, ii)] / E2W;
  float revg = 1. / gamma[hook(5, ii)];
  float revg2 = revg * revg;
  float wug = wu[hook(6, ii)] * revg;
  float wgwu = w[hook(7, ii)] * revg / wu[hook(6, ii)];
  n.x = ddphi[hook(9, ii)];
  n.y = ddpsi[hook(10, ii)];

  n.z = 1 - HALF * (n.x * n.x + n.y * n.y);

  for (j = 0; j < jend; j++) {
    sintg = sincos(tg[hook(11, j)], &costg);
    sintgph = sincos(tg[hook(11, j)] + phase, &costgph);
    sin2tg = TWO * sintg * costg;
    sin2tgph = TWO * sintgph * costgph;
    ucos = ww1[hook(8, ii)] * tg[hook(11, j)] + wgwu * (-Ky * n.x * (sintg + alphaS * (1. - costg - tg[hook(11, j)] * sintg)) + Kx * n.y * sintgph + 0.125 * revg * (Ky2 * (sin2tg - TWO * alphaS * (tg[hook(11, j)] * tg[hook(11, j)] + costg * costg + tg[hook(11, j)] * sin2tg)) + Kx2 * sin2tgph));

    sinucos = sincos(ucos, &cosucos);
    eucos.x = cosucos;
    eucos.y = sinucos;

    beta.x = Ky * revg * costg * (1 - alphaS * tg[hook(11, j)]);
    beta.y = -Kx * revg * costgph;
    beta.z = 1 - HALF * (revg2 + beta.x * beta.x + beta.y * beta.y);

    betaP.x = -Ky * wug * (alphaS * costg + (1 - alphaS * tg[hook(11, j)]) * sintg);
    betaP.y = Kx * wug * sintgph;
    betaP.z = wu[hook(6, ii)] * revg2 * (Kx2 * sintgph * costgph + Ky2 * (1 - alphaS * tg[hook(11, j)]) * (alphaS * costg * costg + (1 - alphaS * tg[hook(11, j)]) * sintg * costg));

    if (isHiPrecision) {
      krel = 1. - dot(n, beta);
      nnb = cross(n, cross((n - beta), betaP)) / (krel * krel);
    } else
      nnb = (n - beta) * w[hook(7, ii)];

    Is += (ag[hook(12, j)] * nnb.x) * eucos;
    Ip += (ag[hook(12, j)] * nnb.y) * eucos;
  }

  mem_fence(0x01);
  Is_gl[hook(13, ii)] = Is;
  Ip_gl[hook(14, ii)] = Ip;
}