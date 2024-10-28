//{"b1":0,"ic":3,"m":7,"n":4,"nc":1,"nr":2,"r":5,"tmp":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float GAMMA = 42.57748f;
constant float TWOPI = 6.283185307179586476925286766559005768394338798750211641949889185f;
void rotmn(const float* n, float* m, float* r) {
  float phi, hp, cp, sp, ar, ai, br, bi, arar, aiai, arai2, brbr, bibi, brbi2, arbi2, aibr2, arbr2, aibi2, brmbi, brpbi, armai, arpai, tmp[3];

  phi = sqrt(n[hook(4, 0)] * n[hook(4, 0)] + n[hook(4, 1)] * n[hook(4, 1)] + n[hook(4, 2)] * n[hook(4, 2)]);

  if (phi) {
    hp = .5 * phi;
    cp = cos(hp);
    sp = sin(hp) / phi;
    ar = cp;
    ai = -n[hook(4, 2)] * sp;
    br = n[hook(4, 1)] * sp;
    bi = -n[hook(4, 0)] * sp;

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

    r[hook(5, 0)] = armai - brmbi;
    r[hook(5, 1)] = -arai2 - brbi2;
    r[hook(5, 2)] = -arbr2 + aibi2;
    r[hook(5, 3)] = arai2 - brbi2;
    r[hook(5, 4)] = armai + brmbi;
    r[hook(5, 5)] = -aibr2 - arbi2;
    r[hook(5, 6)] = arbr2 + aibi2;
    r[hook(5, 7)] = arbi2 - aibr2;
    r[hook(5, 8)] = arpai - brpbi;

    tmp[hook(6, 0)] = r[hook(5, 0)] * m[hook(7, 0)] + r[hook(5, 3)] * m[hook(7, 1)] + r[hook(5, 6)] * m[hook(7, 2)];
    tmp[hook(6, 1)] = r[hook(5, 1)] * m[hook(7, 0)] + r[hook(5, 4)] * m[hook(7, 1)] + r[hook(5, 7)] * m[hook(7, 2)];
    tmp[hook(6, 2)] = r[hook(5, 2)] * m[hook(7, 0)] + r[hook(5, 5)] * m[hook(7, 1)] + r[hook(5, 8)] * m[hook(7, 2)];

    m[hook(7, 0)] = tmp[hook(6, 0)];
    m[hook(7, 1)] = tmp[hook(6, 1)];
    m[hook(7, 2)] = tmp[hook(6, 2)];
  }
}

kernel void intcor(global const float* b1, const unsigned nc, const unsigned nr, global float* ic) {
  unsigned pos = get_global_id(0), int2 = pos + pos, pos21 = int2 + 1, nr2 = 2 * nr, pos21nr, pos2nr;

  ic[hook(3, pos)] = 0.;
  for (unsigned r = 0; r < nr2 * nc; r += nr2) {
    pos2nr = int2 + r;
    pos21nr = pos21 + r;
    ic[hook(3, pos)] += b1[hook(0, pos2nr)] * b1[hook(0, pos2nr)] + b1[hook(0, pos21nr)] * b1[hook(0, pos21nr)];
  }
  ic[hook(3, pos)] = 1.0 / ic[hook(3, pos)];
}