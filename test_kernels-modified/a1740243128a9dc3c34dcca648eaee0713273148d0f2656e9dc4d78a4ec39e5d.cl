//{"Ip_gl":14,"Is_gl":13,"Kx":1,"Ky":2,"ag":12,"alpha":0,"ddpsi":10,"ddtheta":9,"gamma":5,"jend":4,"phase":3,"tg":11,"w":7,"wu":6,"ww1":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void undulator_taper(const float alpha, const float Kx, const float Ky, const float phase, const int jend, global float* gamma, global float* wu, global float* w, global float* ww1, global float* ddtheta, global float* ddpsi, global float* tg, global float* ag, global float2* Is_gl, global float2* Ip_gl) {
  const float E2W = 1.51926751475e15;
  const float C = 2.99792458e11;
  unsigned int ii = get_global_id(0);
  int j;

  float2 eucos, beta;
  float ucos, sintg, sin2tg, costg;
  float2 zero2 = (float2)(0, 0);
  float2 Is = zero2;
  float2 Ip = zero2;
  float Kx2 = Kx * Kx;
  float Ky2 = Ky * Ky;
  float alphaS = alpha * C / wu[hook(6, ii)] / E2W;
  float wgwu = w[hook(7, ii)] / gamma[hook(5, ii)] / wu[hook(6, ii)];
  for (j = 0; j < jend; j++) {
    sintg = sin(tg[hook(11, j)]);
    sin2tg = sin(2 * tg[hook(11, j)]);
    costg = cos(tg[hook(11, j)]);
    ucos = ww1[hook(8, ii)] * tg[hook(11, j)] + wgwu * (-Ky * ddtheta[hook(9, ii)] * (sintg + alphaS * (1 - costg - tg[hook(11, j)] * sintg)) + Kx * ddpsi[hook(10, ii)] * sin(tg[hook(11, j)] + phase) + 0.125 / gamma[hook(5, ii)] * (Ky2 * (sin2tg - 2 * alphaS * (tg[hook(11, j)] * tg[hook(11, j)] + costg * costg + tg[hook(11, j)] * sin2tg)) + Kx2 * sin(2. * (tg[hook(11, j)] + phase))));

    eucos.x = cos(ucos);
    eucos.y = sin(ucos);

    beta.x = -Ky / gamma[hook(5, ii)] * costg;
    beta.y = Kx / gamma[hook(5, ii)] * cos(tg[hook(11, j)] + phase);

    Is += ag[hook(12, j)] * (ddtheta[hook(9, ii)] + beta.x * (1 - alphaS * tg[hook(11, j)])) * eucos;
    Ip += ag[hook(12, j)] * (ddpsi[hook(10, ii)] + beta.y) * eucos;
  }
  mem_fence(0x01);
  Is_gl[hook(13, ii)] = Is;
  Ip_gl[hook(14, ii)] = Ip;
}