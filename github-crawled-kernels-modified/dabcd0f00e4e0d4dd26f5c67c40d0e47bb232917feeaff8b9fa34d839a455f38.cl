//{"Ip_gl":14,"Is_gl":13,"Kx":1,"Ky":2,"ag":12,"alpha":0,"ddphi":9,"ddpsi":10,"gamma":5,"jend":4,"phase":3,"tg":11,"w":7,"wu":6,"ww1":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void undulator(const float alpha, const float Kx, const float Ky, const float phase, const int jend, global float* gamma, global float* wu, global float* w, global float* ww1, global float* ddphi, global float* ddpsi, global float* tg, global float* ag, global float2* Is_gl, global float2* Ip_gl) {
  unsigned int ii = get_global_id(0);
  int j;

  float2 beta;
  float2 eucos;
  float ucos;
  float2 zero2 = (float2)(0, 0);
  float2 Is = zero2;
  float2 Ip = zero2;
  float wgwu = w[hook(7, ii)] / gamma[hook(5, ii)] / wu[hook(6, ii)];
  float Kx2 = Kx * Kx;
  float Ky2 = Ky * Ky;
  for (j = 0; j < jend; j++) {
    ucos = (double)(ww1[hook(8, ii)]) * tg[hook(11, j)] + wgwu * (-Ky * ddphi[hook(9, ii)] * (sin(tg[hook(11, j)])) + Kx * ddpsi[hook(10, ii)] * sin(tg[hook(11, j)] + phase) + 0.125 / gamma[hook(5, ii)] * (Ky2 * sin(2. * tg[hook(11, j)]) + Kx2 * sin(2. * (tg[hook(11, j)] + phase))));

    eucos.x = cos(ucos);
    eucos.y = sin(ucos);

    beta.x = -Ky / gamma[hook(5, ii)] * cos(tg[hook(11, j)]);
    beta.y = Kx / gamma[hook(5, ii)] * cos(tg[hook(11, j)] + phase);

    Is += (ag[hook(12, j)] * (ddphi[hook(9, ii)] + beta.x)) * eucos;
    Ip += (ag[hook(12, j)] * (ddpsi[hook(10, ii)] + beta.y)) * eucos;
  }
  mem_fence(0x01);
  Is_gl[hook(13, ii)] = Is;
  Ip_gl[hook(14, ii)] = Ip;
}