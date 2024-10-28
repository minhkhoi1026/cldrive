//{"b0":3,"b1":0,"dt":10,"g":1,"gs":4,"ic":6,"lm":16,"lr":19,"ls":18,"ls[c]":17,"m":14,"m0":5,"n":12,"nc":8,"nk":9,"nr":7,"nv":15,"r":2,"rf":11,"tmp":13}
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

    r[hook(2, 0)] = armai - brmbi;
    r[hook(2, 1)] = -arai2 - brbi2;
    r[hook(2, 2)] = -arbr2 + aibi2;
    r[hook(2, 3)] = arai2 - brbi2;
    r[hook(2, 4)] = armai + brmbi;
    r[hook(2, 5)] = -aibr2 - arbi2;
    r[hook(2, 6)] = arbr2 + aibi2;
    r[hook(2, 7)] = arbi2 - aibr2;
    r[hook(2, 8)] = arpai - brpbi;

    tmp[hook(13, 0)] = r[hook(2, 0)] * m[hook(14, 0)] + r[hook(2, 3)] * m[hook(14, 1)] + r[hook(2, 6)] * m[hook(14, 2)];
    tmp[hook(13, 1)] = r[hook(2, 1)] * m[hook(14, 0)] + r[hook(2, 4)] * m[hook(14, 1)] + r[hook(2, 7)] * m[hook(14, 2)];
    tmp[hook(13, 2)] = r[hook(2, 2)] * m[hook(14, 0)] + r[hook(2, 5)] * m[hook(14, 1)] + r[hook(2, 8)] * m[hook(14, 2)];

    m[hook(14, 0)] = tmp[hook(13, 0)];
    m[hook(14, 1)] = tmp[hook(13, 1)];
    m[hook(14, 2)] = tmp[hook(13, 2)];
  }
}

kernel void simacq(const global float* b1, const global float* g, const global float* r, const global float* b0, const global float* gs, const global float* m0, const global float* ic, const unsigned nr, const unsigned nc, const unsigned nk, const float dt, global float* rf) {
  unsigned pos = get_global_id(0);
  unsigned os = pos * 3;
  float nv[3];
  float lm[3];
  float ls[8][2];
  float rot[9];
  float tm[3];

  float gdt = GAMMA * TWOPI * dt;
  float rdt = 1.0e-3 * dt * TWOPI;
  float tmp[2];
  float lr[3] = {r[hook(2, os)] * gs[hook(4, os)], r[hook(2, os + 1)] * gs[hook(4, os + 1)], r[hook(2, os + 2)] * gs[hook(4, os + 2)]};

  nv[hook(15, 0)] = 0.0;
  nv[hook(15, 1)] = 0.0;

  lm[hook(16, 0)] = m0[hook(5, os)] * ic[hook(6, pos)];
  lm[hook(16, 1)] = m0[hook(5, os + 1)] * ic[hook(6, pos)];
  lm[hook(16, 2)] = m0[hook(5, os + 2)] * ic[hook(6, pos)];

  if (lm[hook(16, 0)] + lm[hook(16, 1)] + lm[hook(16, 2)] > 0.0) {
    unsigned t, c, t3;

    for (c = 0; c < nc; ++c) {
      unsigned b1os = 2 * (pos + c * nr);
      ls[hook(18, c)][hook(17, 0)] = b1[hook(0, b1os)];
      ls[hook(18, c)][hook(17, 1)] = b1[hook(0, 1 + b1os)];
    }

    for (t = 0, t3 = (nk - 1 - t) * 3; t < nk; ++t) {
      tmp[hook(13, 0)] = lm[hook(16, 0)];
      tmp[hook(13, 1)] = lm[hook(16, 1)];

      nv[hook(15, 2)] = -gdt * (-g[hook(1, t3)] * lr[hook(19, 0)] + -g[hook(1, 1 + t3)] * lr[hook(19, 1)] + -g[hook(1, 2 + t3)] * lr[hook(19, 2)] - t * rdt * b0[hook(3, pos)]);
      t3 -= 3;

      rotmn(nv, lm, rot);

      tmp[hook(13, 0)] += lm[hook(16, 0)];
      tmp[hook(13, 1)] += lm[hook(16, 1)];

      unsigned st = (nk - 1 - t) + pos * nk * nc;
      for (c = 0; c < nc; ++c) {
        unsigned stcnk = 2 * (st + c * nk);
        rf[hook(11, stcnk)] = tmp[hook(13, 0)] * ls[hook(18, c)][hook(17, 0)] + tmp[hook(13, 1)] * ls[hook(18, c)][hook(17, 1)];
        rf[hook(11, stcnk + 1)] = tmp[hook(13, 0)] * ls[hook(18, c)][hook(17, 0)] + tmp[hook(13, 1)] * ls[hook(18, c)][hook(17, 1)];
      }
    }
  }
}