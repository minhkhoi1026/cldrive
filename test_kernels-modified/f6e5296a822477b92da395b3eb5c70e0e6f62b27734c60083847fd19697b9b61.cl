//{"b0":4,"b1":0,"dt":10,"g":1,"gs":5,"lm":14,"lr":18,"ls":16,"ls[c]":15,"m":11,"m0":6,"n":12,"nc":8,"nk":9,"nr":7,"nv":17,"r":3,"rf":2,"tmp":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float GAMMA = 42.57748f;
constant float TWOPI = 6.283185307179586476925286766559005768394338798750211641949889185f;
void rotmn(const float* n, float* m, float* r) {
  float phi, hp, cp, sp, ar, ai, br, bi, arar, aiai, arai2, brbr, bibi, brbi2, arbi2, aibr2, arbr2, aibi2, brmbi, brpbi, armai, arpai, tmp[3];

  phi = sqrt(n[hook(12, 0)] * n[hook(12, 0)] + n[hook(12, 1)] * n[hook(12, 1)] + n[hook(12, 2)] * n[hook(12, 2)]);

  if (phi) {
    hp = .5 * phi;
    cp = cos(hp);
    sp = sin(hp) / phi;
    ar = cp;
    ai = -n[hook(12, 2)] * sp;
    br = n[hook(12, 1)] * sp;
    bi = -n[hook(12, 0)] * sp;

    arar = ar * ar;
    aiai = ai * ai;
    arai2 = 2. * ar * ai;
    brbr = br * br;
    bibi = bi * bi;
    brbi2 = 2. * br * bi;
    arbi2 = 2. * ar * bi;
    aibr2 = 2. * ai * br;
    arbr2 = 2. * ar * br;
    aibi2 = 2. * ai * bi;
    brmbi = brbr - bibi;
    brpbi = brbr + bibi;
    armai = arar - aiai;
    arpai = arar + aiai;

    r[hook(3, 0)] = armai - brmbi;
    r[hook(3, 1)] = -arai2 - brbi2;
    r[hook(3, 2)] = -arbr2 + aibi2;
    r[hook(3, 3)] = arai2 - brbi2;
    r[hook(3, 4)] = armai + brmbi;
    r[hook(3, 5)] = -aibr2 - arbi2;
    r[hook(3, 6)] = arbr2 + aibi2;
    r[hook(3, 7)] = arbi2 - aibr2;
    r[hook(3, 8)] = arpai - brpbi;

    tmp[hook(13, 0)] = r[hook(3, 0)] * m[hook(11, 0)] + r[hook(3, 3)] * m[hook(11, 1)] + r[hook(3, 6)] * m[hook(11, 2)];
    tmp[hook(13, 1)] = r[hook(3, 1)] * m[hook(11, 0)] + r[hook(3, 4)] * m[hook(11, 1)] + r[hook(3, 7)] * m[hook(11, 2)];
    tmp[hook(13, 2)] = r[hook(3, 2)] * m[hook(11, 0)] + r[hook(3, 5)] * m[hook(11, 1)] + r[hook(3, 8)] * m[hook(11, 2)];

    m[hook(11, 0)] = tmp[hook(13, 0)];
    m[hook(11, 1)] = tmp[hook(13, 1)];
    m[hook(11, 2)] = tmp[hook(13, 2)];
  }
}

kernel void simexc(const global float* b1, const global float* g, const global float* rf, const global float* r, const global float* b0, const global float* gs, const global float* m0, const unsigned nr, const unsigned nc, const unsigned nk, const float dt, global float* m) {
  unsigned pos = get_global_id(0);
  int os = 3 * pos;

  float lm[3] = {0., 0., 1.};
  lm[hook(14, 0)] = m0[hook(6, os)];
  lm[hook(14, 1)] = m0[hook(6, os + 1)];
  lm[hook(14, 2)] = m0[hook(6, os + 2)];

  if (lm[hook(14, 0)] + lm[hook(14, 1)] + lm[hook(14, 2)] > 0.0) {
    float nv[3];
    float ls[8][2];
    float rot[9];
    float tm[3];
    float lr[3] = {r[hook(3, os)] * gs[hook(5, os)], r[hook(3, os + 1)] * gs[hook(5, os + 1)], r[hook(3, os + 2)] * gs[hook(5, os + 2)]};

    float gdt = GAMMA * TWOPI * dt;
    float rdt = 1.0e-3 * dt * TWOPI;

    unsigned t, c, t3;

    for (c = 0; c < nc; ++c) {
      int cpos = 2 * (pos + c * nr);
      ls[hook(16, c)][hook(15, 0)] = b1[hook(0, cpos)];
      ls[hook(16, c)][hook(15, 1)] = b1[hook(0, cpos + 1)];
    }

    for (t = 0, t3 = 0; t < nk; ++t) {
      float rfsr = 0., rfsi = 0.;

      for (c = 0; c < nc; c++) {
        unsigned rfos = 2 * (t + c * nk);
        rfsr += rf[hook(2, rfos)] * ls[hook(16, c)][hook(15, 0)] - rf[hook(2, rfos + 1)] * ls[hook(16, c)][hook(15, 1)];
        rfsi += rf[hook(2, rfos)] * ls[hook(16, c)][hook(15, 1)] + rf[hook(2, rfos + 1)] * ls[hook(16, c)][hook(15, 0)];
      }

      nv[hook(17, 0)] = -rdt * rfsi;
      nv[hook(17, 1)] = rdt * rfsr;
      nv[hook(17, 2)] = -gdt * (g[hook(1, t3++)] * lr[hook(18, 0)] + g[hook(1, t3++)] * lr[hook(18, 1)] + g[hook(1, t3++)] * lr[hook(18, 2)] - t * rdt * b0[hook(4, pos)]);

      rotmn(nv, lm, rot);
    }

    m[hook(11, os)] = lm[hook(14, 0)];
    m[hook(11, os + 1)] = lm[hook(14, 1)];
    m[hook(11, os + 2)] = lm[hook(14, 2)];
  } else {
    m[hook(11, os)] = 0.;
    m[hook(11, os + 1)] = 0.;
    m[hook(11, os + 2)] = 0.;
  }
}