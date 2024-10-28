//{"Ip_gl":13,"Is_gl":12,"Kx":1,"Ky":2,"R0":0,"ag":11,"ddphi":8,"ddpsi":9,"gamma":5,"jend":4,"phase":3,"tg":10,"w":7,"wu":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void undulator_nf(const float R0, const float Kx, const float Ky, const float phase, const int jend, global float* gamma, global float* wu, global float* w, global float* ddphi, global float* ddpsi, global float* tg, global float* ag, global float2* Is_gl, global float2* Ip_gl) {
  const float E2W = 1.51926751475e15;
  const float C = 2.99792458e11;

  unsigned int ii = get_global_id(0);
  int j;

  float2 eucos;
  float ucos;
  float2 zero2 = (float2)(0, 0);
  float2 Is = zero2;
  float2 Ip = zero2;
  float3 r, r0;
  float2 beta;
  float Kx2 = Kx * Kx;
  float Ky2 = Ky * Ky;
  float gamma2 = gamma[hook(5, ii)] * gamma[hook(5, ii)];
  float betam = 1 - (1 + 0.5 * Kx2 + 0.5 * Ky2) / 2. / gamma2;

  float wR0 = R0 / C * E2W;
  r0.x = wR0 * tan(-ddphi[hook(8, ii)]);
  r0.y = wR0 * tan(ddpsi[hook(9, ii)]);
  r0.z = wR0 * cos(sqrt(ddphi[hook(8, ii)] * ddphi[hook(8, ii)] + ddpsi[hook(9, ii)] * ddpsi[hook(9, ii)]));

  for (j = 0; j < jend; j++) {
    r.x = Ky / wu[hook(6, ii)] / gamma[hook(5, ii)] * sin(tg[hook(10, j)]);
    r.y = -Kx / wu[hook(6, ii)] / gamma[hook(5, ii)] * sin(tg[hook(10, j)] + phase);
    r.z = betam * tg[hook(10, j)] / wu[hook(6, ii)] - 0.125 / wu[hook(6, ii)] / gamma2 * (Ky2 * sin(2 * tg[hook(10, j)]) + Kx2 * sin(2 * (tg[hook(10, j)] + phase)));

    ucos = w[hook(7, ii)] * (tg[hook(10, j)] / wu[hook(6, ii)] + length(r0 - r));

    eucos.x = cos(ucos);
    eucos.y = sin(ucos);

    beta.x = -Ky / gamma[hook(5, ii)] * cos(tg[hook(10, j)]);
    beta.y = Kx / gamma[hook(5, ii)] * cos(tg[hook(10, j)] + phase);

    Is += ag[hook(11, j)] * (-ddphi[hook(8, ii)] + beta.x) * eucos;
    Ip += ag[hook(11, j)] * (ddpsi[hook(9, ii)] + beta.y) * eucos;
  }
  mem_fence(0x01);

  Is_gl[hook(12, ii)] = Is;
  Ip_gl[hook(13, ii)] = Ip;
}