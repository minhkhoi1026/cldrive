//{"Ip_gl":16,"Is_gl":15,"Kx":1,"Ky":2,"ag":14,"alpha":0,"beta0x":11,"beta0y":12,"ddphi":9,"ddpsi":10,"gamma":5,"jend":4,"phase":3,"tg":13,"w":7,"wu":6,"ww1":8}
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
kernel void undulator_full(const float alpha, const float Kx, const float Ky, const float phase, const int jend, global float* gamma, global float* wu, global float* w, global float* ww1, global float* ddphi, global float* ddpsi, global float* beta0x, global float* beta0y, global float* tg, global float* ag, global float2* Is_gl, global float2* Ip_gl) {
  unsigned int ii = get_global_id(0);
  int j;

  float2 eucos;
  float2 beta0 = (float2)(beta0x[hook(11, ii)], beta0y[hook(12, ii)]);
  float ucos, sinucos, cosucos, sintg, costg, sintgph, costgph, krel;
  float2 Is = zero2;
  float2 Ip = zero2;
  float3 r, n, nnb, beta, betaP;
  float Kx2 = Kx * Kx;
  float Ky2 = Ky * Ky;
  float revg = 1. / gamma[hook(5, ii)];
  float revg2 = revg * revg;
  float wug = wu[hook(6, ii)] * revg;
  float wwu = w[hook(7, ii)] / wu[hook(6, ii)];
  float betam = 1 - (1 + HALF * Kx2 + HALF * Ky2) * HALF * revg2;

  n.x = ddphi[hook(9, ii)];
  n.y = ddpsi[hook(10, ii)];

  n.z = 1 - HALF * (n.x * n.x + n.y * n.y);

  for (j = 0; j < jend; j++) {
    sintg = sincos(tg[hook(13, j)], &costg);
    sintgph = sincos(tg[hook(13, j)] + phase, &costgph);

    beta.x = Ky * costg * revg + beta0.x;
    beta.y = -Kx * costgph * revg + beta0.y;
    beta.z = 1. - HALF * (revg2 + beta.x * beta.x + beta.y * beta.y);

    r.x = Ky * sintg * revg + beta0.x * tg[hook(13, j)];
    r.y = -Kx * sintgph * revg + beta0.y * tg[hook(13, j)];
    r.z = -QUAR * revg2 * (Kx2 * sintgph * costgph + Ky2 * sintg * costg) + tg[hook(13, j)] * betam + Kx * beta0.y * sintgph * revg - Ky * beta0.x * sintg * revg - tg[hook(13, j)] * HALF * (beta0.x * beta0.x + beta0.y * beta0.y);

    ucos = wwu * (tg[hook(13, j)] - dot(n, r));

    sinucos = sincos(ucos, &cosucos);
    eucos.x = cosucos;
    eucos.y = sinucos;

    betaP.x = -Ky * wug * sintg;
    betaP.y = Kx * wug * sintgph;
    betaP.z = wu[hook(6, ii)] * revg2 * (Ky2 * sintg * costg + Kx2 * sintgph * costgph);

    if (isHiPrecision) {
      krel = 1. - dot(n, beta);
      nnb = cross(n, cross((n - beta), betaP)) / (krel * krel);
    } else
      nnb = (n - beta) * w[hook(7, ii)];

    Is += (ag[hook(14, j)] * nnb.x) * eucos;
    Ip += (ag[hook(14, j)] * nnb.y) * eucos;
  }

  mem_fence(0x01);

  Is_gl[hook(15, ii)] = Is;
  Ip_gl[hook(16, ii)] = Ip;
}