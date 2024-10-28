//{"j":1,"m":9,"n":6,"nc":2,"nk":3,"nr":4,"r":7,"rf":5,"srep":0,"tmp":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float GAMMA = 42.57748f;
constant float TWOPI = 6.283185307179586476925286766559005768394338798750211641949889185f;
void rotmn(const float* n, float* m, float* r) {
  float phi, hp, cp, sp, ar, ai, br, bi, arar, aiai, arai2, brbr, bibi, brbi2, arbi2, aibr2, arbr2, aibi2, brmbi, brpbi, armai, arpai, tmp[3];

  phi = sqrt(n[hook(6, 0)] * n[hook(6, 0)] + n[hook(6, 1)] * n[hook(6, 1)] + n[hook(6, 2)] * n[hook(6, 2)]);

  if (phi) {
    hp = .5 * phi;
    cp = cos(hp);
    sp = sin(hp) / phi;
    ar = cp;
    ai = -n[hook(6, 2)] * sp;
    br = n[hook(6, 1)] * sp;
    bi = -n[hook(6, 0)] * sp;

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

    r[hook(7, 0)] = armai - brmbi;
    r[hook(7, 1)] = -arai2 - brbi2;
    r[hook(7, 2)] = -arbr2 + aibi2;
    r[hook(7, 3)] = arai2 - brbi2;
    r[hook(7, 4)] = armai + brmbi;
    r[hook(7, 5)] = -aibr2 - arbi2;
    r[hook(7, 6)] = arbr2 + aibi2;
    r[hook(7, 7)] = arbi2 - aibr2;
    r[hook(7, 8)] = arpai - brpbi;

    tmp[hook(8, 0)] = r[hook(7, 0)] * m[hook(9, 0)] + r[hook(7, 3)] * m[hook(9, 1)] + r[hook(7, 6)] * m[hook(9, 2)];
    tmp[hook(8, 1)] = r[hook(7, 1)] * m[hook(9, 0)] + r[hook(7, 4)] * m[hook(9, 1)] + r[hook(7, 7)] * m[hook(9, 2)];
    tmp[hook(8, 2)] = r[hook(7, 2)] * m[hook(9, 0)] + r[hook(7, 5)] * m[hook(9, 1)] + r[hook(7, 8)] * m[hook(9, 2)];

    m[hook(9, 0)] = tmp[hook(8, 0)];
    m[hook(9, 1)] = tmp[hook(8, 1)];
    m[hook(9, 2)] = tmp[hook(8, 2)];
  }
}

kernel void redsig(const global float* srep, const global float* j, const unsigned nc, const unsigned nk, const unsigned nr, global float* rf) {
  unsigned sample = get_global_id(0);
  unsigned slen = 2 * nc * nk;
  rf[hook(5, sample)] = 0.;
  for (unsigned r = 0; r < nr * slen; r += slen)
    rf[hook(5, sample)] += srep[hook(0, r + sample)];
  rf[hook(5, sample)] *= j[hook(1, sample % nk)];
  return;
}