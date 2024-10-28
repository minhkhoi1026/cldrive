//{"Ip_gl":15,"Is_gl":14,"Kx":2,"Ky":3,"L0":1,"R0":0,"ag":13,"ddphi":10,"ddpsi":11,"gamma":6,"jend":5,"phase":4,"tg":12,"w":8,"wu":7,"ww1":9}
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
kernel void undulator_nf(const float R0, const float L0, const float Kx, const float Ky, const float phase, const int jend, global float* gamma, global float* wu, global float* w, global float* ww1, global float* ddphi, global float* ddpsi, global float* tg, global float* ag, global float2* Is_gl, global float2* Ip_gl) {
  unsigned int ii = get_global_id(0);
  int j;

  float2 eucos;
  float ucos, sinucos, cosucos, sintg, costg, sintgph, costgph, krel;
  float2 Is = zero2;
  float2 Ip = zero2;
  float3 r, r0, n, nnb, beta, betaP;
  float Kx2 = Kx * Kx;
  float Ky2 = Ky * Ky;
  float revg = 1. / gamma[hook(6, ii)];
  float revg2 = revg * revg;
  float wug = wu[hook(7, ii)] * revg;
  float wwu = w[hook(8, ii)] / wu[hook(7, ii)];
  float betam = 1 - (1 + HALF * Kx2 + HALF * Ky2) * HALF * revg2;
  float wR0 = R0 * PI2 / L0;

  r0.x = wR0 * tan(ddphi[hook(10, ii)]);
  r0.y = wR0 * tan(ddpsi[hook(11, ii)]);
  r0.z = wR0 * cos(sqrt(ddphi[hook(10, ii)] * ddphi[hook(10, ii)] + ddpsi[hook(11, ii)] * ddpsi[hook(11, ii)]));

  n.x = ddphi[hook(10, ii)];
  n.y = ddpsi[hook(11, ii)];

  n.z = 1 - HALF * (n.x * n.x + n.y * n.y);

  for (j = 0; j < jend; j++) {
    sintg = sincos(tg[hook(12, j)], &costg);
    sintgph = sincos(tg[hook(12, j)] + phase, &costgph);

    r.x = Ky * revg * sintg;
    r.y = -Kx * revg * sintgph;
    r.z = betam * tg[hook(12, j)] - QUAR * revg2 * (Ky2 * sintg * costg + Kx2 * sintgph * costgph);

    ucos = wwu * (tg[hook(12, j)] + length(r0 - r));

    sinucos = sincos(ucos, &cosucos);
    eucos.x = cosucos;
    eucos.y = sinucos;

    beta.x = Ky * revg * costg;
    beta.y = -Kx * revg * costgph;

    beta.z = 1 - HALF * (revg2 + beta.x * beta.x + beta.y * beta.y);

    betaP.x = -Ky * wug * sintg;
    betaP.y = Kx * wug * sintgph;
    betaP.z = wu[hook(7, ii)] * revg2 * (Ky2 * sintg * costg + Kx2 * sintgph * costgph);

    if (isHiPrecision) {
      krel = 1. - dot(n, beta);
      nnb = cross(n, cross((n - beta), betaP)) / (krel * krel);

    } else
      nnb = (n - beta) * w[hook(8, ii)];

    Is += (ag[hook(13, j)] * nnb.x) * eucos;
    Ip += (ag[hook(13, j)] * nnb.y) * eucos;
  }

  mem_fence(0x01);

  Is_gl[hook(14, ii)] = Is;
  Ip_gl[hook(15, ii)] = Ip;
}