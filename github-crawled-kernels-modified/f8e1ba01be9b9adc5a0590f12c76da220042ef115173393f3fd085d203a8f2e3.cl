//{"Neffect_radius":7,"Nq":3,"background":9,"charge":10,"cutoff":6,"dielectconst":14,"gMSAWave":15,"loops":5,"loops_g":4,"qx":0,"qy":1,"result":2,"saltconc":13,"scale":8,"temperature":12,"volfraction":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float Iq(float QQ, float effect_radius, float zz, float VolFrac, float Temp, float csalt, float dialec);
int sqcoef(int ir, float gMSAWave[]);
int sqfun(int ix, int ir, float gMSAWave[]);
float sqhcal(float qq, float gMSAWave[]);
float Iq(float QQ, float effect_radius, float zz, float VolFrac, float Temp, float csalt, float dialec) {
  float gMSAWave[17] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17};
  float Elcharge = 1.602189e-19f;
  float kB = 1.380662e-23f;
  float FrSpPerm = 8.85418782E-12f;
  float SofQ, Qdiam, Vp, ss;
  float SIdiam, diam, Kappa, cs, IonSt;
  float Perm, Beta;
  float pi, charge;
  int ierr;

  pi = 3.14159265358979323846f;

  diam = 2 * effect_radius;

  Beta = 1.0f / (kB * Temp);
  Perm = dialec * FrSpPerm;
  charge = zz * Elcharge;
  SIdiam = diam * 1.0E-10f;
  Vp = 4.0f * pi / 3.0f * (SIdiam / 2.0f) * (SIdiam / 2.0f) * (SIdiam / 2.0f);
  cs = csalt * 6.022E23f * 1.0E3f;

  IonSt = 0.5f * Elcharge * Elcharge * (zz * VolFrac / Vp + 2.0f * cs);
  Kappa = sqrt(2 * Beta * IonSt / Perm);

  gMSAWave[hook(15, 5)] = Beta * charge * charge / (pi * Perm * SIdiam * pow((2.0f + Kappa * SIdiam), 2));

  Qdiam = QQ * diam;
  gMSAWave[hook(15, 6)] = Kappa * SIdiam;
  gMSAWave[hook(15, 4)] = VolFrac;

  ss = pow(gMSAWave[hook(15, 4)], (1.0f / 3.0f));
  gMSAWave[hook(15, 9)] = 2.0f * ss * gMSAWave[hook(15, 5)] * exp(gMSAWave[hook(15, 6)] - gMSAWave[hook(15, 6)] / ss);

  ierr = 0;
  ierr = sqcoef(ierr, gMSAWave);
  if (ierr >= 0) {
    SofQ = sqhcal(Qdiam, gMSAWave);
  } else {
    SofQ = -1.0f;
  }

  return (SofQ);
}
int sqcoef(int ir, float gMSAWave[]) {
  int itm = 40, ix, ig, ii;
  float acc = 5.0E-6f, del, e1, e2, f1, f2;

  f1 = 0;
  f2 = 0;

  ig = 1;
  if (gMSAWave[hook(15, 6)] >= (1.0f + 8.0f * gMSAWave[hook(15, 4)])) {
    ig = 0;
    gMSAWave[hook(15, 15)] = gMSAWave[hook(15, 14)];
    gMSAWave[hook(15, 16)] = gMSAWave[hook(15, 4)];
    ix = 1;
    ir = sqfun(ix, ir, gMSAWave);
    gMSAWave[hook(15, 14)] = gMSAWave[hook(15, 15)];
    gMSAWave[hook(15, 4)] = gMSAWave[hook(15, 16)];
    if ((ir < 0.0f) || (gMSAWave[hook(15, 14)] >= 0.0f)) {
      return ir;
    }
  }
  gMSAWave[hook(15, 10)] = fmin(gMSAWave[hook(15, 4)], 0.20f);
  if ((ig != 1) || (gMSAWave[hook(15, 9)] >= 0.15f)) {
    ii = 0;
    do {
      ii = ii + 1;
      if (ii > itm) {
        ir = -1;
        return ir;
      }
      if (gMSAWave[hook(15, 10)] <= 0.0f) {
        gMSAWave[hook(15, 10)] = gMSAWave[hook(15, 4)] / ii;
      }
      if (gMSAWave[hook(15, 10)] > 0.6f) {
        gMSAWave[hook(15, 10)] = 0.35f / ii;
      }
      e1 = gMSAWave[hook(15, 10)];
      gMSAWave[hook(15, 15)] = f1;
      gMSAWave[hook(15, 16)] = e1;
      ix = 2;
      ir = sqfun(ix, ir, gMSAWave);
      f1 = gMSAWave[hook(15, 15)];
      e1 = gMSAWave[hook(15, 16)];
      e2 = gMSAWave[hook(15, 10)] * 1.01f;
      gMSAWave[hook(15, 15)] = f2;
      gMSAWave[hook(15, 16)] = e2;
      ix = 2;
      ir = sqfun(ix, ir, gMSAWave);
      f2 = gMSAWave[hook(15, 15)];
      e2 = gMSAWave[hook(15, 16)];
      e2 = e1 - (e2 - e1) * f1 / (f2 - f1);
      gMSAWave[hook(15, 10)] = e2;
      del = fabs((e2 - e1) / e1);
    } while (del > acc);
    gMSAWave[hook(15, 15)] = gMSAWave[hook(15, 14)];
    gMSAWave[hook(15, 16)] = e2;
    ix = 4;
    ir = sqfun(ix, ir, gMSAWave);
    gMSAWave[hook(15, 14)] = gMSAWave[hook(15, 15)];
    e2 = gMSAWave[hook(15, 16)];
    ir = ii;
    if ((ig != 1) || (gMSAWave[hook(15, 10)] >= gMSAWave[hook(15, 4)])) {
      return ir;
    }
  }
  gMSAWave[hook(15, 15)] = gMSAWave[hook(15, 14)];
  gMSAWave[hook(15, 16)] = gMSAWave[hook(15, 4)];
  ix = 3;
  ir = sqfun(ix, ir, gMSAWave);
  gMSAWave[hook(15, 14)] = gMSAWave[hook(15, 15)];
  gMSAWave[hook(15, 4)] = gMSAWave[hook(15, 16)];
  if ((ir >= 0) && (gMSAWave[hook(15, 14)] < 0.0f)) {
    ir = -3;
  }
  return ir;
}

int sqfun(int ix, int ir, float gMSAWave[]) {
  float acc = 1.0e-6f;
  float reta, eta2, eta21, eta22, eta3, eta32, eta2d, eta2d2, eta3d, eta6d, e12, e24, rgek;
  float rak, ak1, ak2, dak, dak2, dak4, d, d2, dd2, dd4, dd45, ex1, ex2, sk, ck, ckma, skma;
  float al1, al2, al3, al4, al5, al6, be1, be2, be3, vu1, vu2, vu3, vu4, vu5, ph1, ph2, ta1, ta2, ta3, ta4, ta5;
  float a1, a2, a3, b1, b2, b3, v1, v2, v3, p1, p2, p3, pp, pp1, pp2, p1p2, t1, t2, t3, um1, um2, um3, um4, um5, um6;
  float w0, w1, w2, w3, w4, w12, w13, w14, w15, w16, w24, w25, w26, w32, w34, w3425, w35, w3526, w36, w46, w56;
  float fa, fap, ca, e24g, pwk, qpw, pg, del, fun, fund, g24;
  int ii, ibig, itm = 40;

  a2 = 0;
  a3 = 0;
  b2 = 0;
  b3 = 0;
  v2 = 0;
  v3 = 0;
  p2 = 0;
  p3 = 0;

  reta = gMSAWave[hook(15, 16)];
  eta2 = reta * reta;
  eta3 = eta2 * reta;
  e12 = 12.0f * reta;
  e24 = e12 + e12;
  gMSAWave[hook(15, 13)] = pow((gMSAWave[hook(15, 4)] / gMSAWave[hook(15, 16)]), (1.0f / 3.0f));
  gMSAWave[hook(15, 12)] = gMSAWave[hook(15, 6)] / gMSAWave[hook(15, 13)];
  ibig = 0;
  if ((gMSAWave[hook(15, 12)] > 15.0f) && (ix == 1)) {
    ibig = 1;
  }

  gMSAWave[hook(15, 11)] = gMSAWave[hook(15, 5)] * gMSAWave[hook(15, 13)] * exp(gMSAWave[hook(15, 6)] - gMSAWave[hook(15, 12)]);
  rgek = gMSAWave[hook(15, 11)];
  rak = gMSAWave[hook(15, 12)];
  ak2 = rak * rak;
  ak1 = 1.0f + rak;
  dak2 = 1.0f / ak2;
  dak4 = dak2 * dak2;
  d = 1.0f - reta;
  d2 = d * d;
  dak = d / rak;
  dd2 = 1.0f / d2;
  dd4 = dd2 * dd2;
  dd45 = dd4 * 2.0e-1f;
  eta3d = 3.0f * reta;
  eta6d = eta3d + eta3d;
  eta32 = eta3 + eta3;
  eta2d = reta + 2.0f;
  eta2d2 = eta2d * eta2d;
  eta21 = 2.0f * reta + 1.0f;
  eta22 = eta21 * eta21;

  al1 = -eta21 * dak;
  al2 = (14.0f * eta2 - 4.0f * reta - 1.0f) * dak2;
  al3 = 36.0f * eta2 * dak4;

  be1 = -(eta2 + 7.0f * reta + 1.0f) * dak;
  be2 = 9.0f * reta * (eta2 + 4.0f * reta - 2.0f) * dak2;
  be3 = 12.0f * reta * (2.0f * eta2 + 8.0f * reta - 1.0f) * dak4;

  vu1 = -(eta3 + 3.0f * eta2 + 45.0f * reta + 5.0f) * dak;
  vu2 = (eta32 + 3.0f * eta2 + 42.0f * reta - 2.0e1f) * dak2;
  vu3 = (eta32 + 3.0e1f * reta - 5.0f) * dak4;
  vu4 = vu1 + e24 * rak * vu3;
  vu5 = eta6d * (vu2 + 4.0f * vu3);

  ph1 = eta6d / rak;
  ph2 = d - e12 * dak2;

  ta1 = (reta + 5.0f) / (5.0f * rak);
  ta2 = eta2d * dak2;
  ta3 = -e12 * rgek * (ta1 + ta2);
  ta4 = eta3d * ak2 * (ta1 * ta1 - ta2 * ta2);
  ta5 = eta3d * (reta + 8.0f) * 1.0e-1f - 2.0f * eta22 * dak2;

  ex1 = exp(rak);
  ex2 = 0.0f;
  if (gMSAWave[hook(15, 12)] < 20.0f) {
    ex2 = exp(-rak);
  }
  sk = 0.5f * (ex1 - ex2);
  ck = 0.5f * (ex1 + ex2);
  ckma = ck - 1.0f - rak * sk;
  skma = sk - rak * ck;

  a1 = (e24 * rgek * (al1 + al2 + ak1 * al3) - eta22) * dd4;
  if (ibig == 0) {
    a2 = e24 * (al3 * skma + al2 * sk - al1 * ck) * dd4;
    a3 = e24 * (eta22 * dak2 - 0.5f * d2 + al3 * ckma - al1 * sk + al2 * ck) * dd4;
  }

  b1 = (1.5f * reta * eta2d2 - e12 * rgek * (be1 + be2 + ak1 * be3)) * dd4;
  if (ibig == 0) {
    b2 = e12 * (-be3 * skma - be2 * sk + be1 * ck) * dd4;
    b3 = e12 * (0.5f * d2 * eta2d - eta3d * eta2d2 * dak2 - be3 * ckma + be1 * sk - be2 * ck) * dd4;
  }

  v1 = (eta21 * (eta2 - 2.0f * reta + 1.0e1f) * 2.5e-1f - rgek * (vu4 + vu5)) * dd45;
  if (ibig == 0) {
    v2 = (vu4 * ck - vu5 * sk) * dd45;
    v3 = ((eta3 - 6.0f * eta2 + 5.0f) * d - eta6d * (2.0f * eta3 - 3.0f * eta2 + 18.0f * reta + 1.0e1f) * dak2 + e24 * vu3 + vu4 * sk - vu5 * ck) * dd45;
  }

  pp1 = ph1 * ph1;
  pp2 = ph2 * ph2;
  pp = pp1 + pp2;
  p1p2 = ph1 * ph2 * 2.0f;
  p1 = (rgek * (pp1 + pp2 - p1p2) - 0.5f * eta2d) * dd2;
  if (ibig == 0) {
    p2 = (pp * sk + p1p2 * ck) * dd2;
    p3 = (pp * ck + p1p2 * sk + pp1 - pp2) * dd2;
  }

  t1 = ta3 + ta4 * a1 + ta5 * b1;
  if (ibig != 0) {
    v3 = ((eta3 - 6.0f * eta2 + 5.0f) * d - eta6d * (2.0f * eta3 - 3.0f * eta2 + 18.0f * reta + 1.0e1f) * dak2 + e24 * vu3) * dd45;
    t3 = ta4 * a3 + ta5 * b3 + e12 * ta2 - 4.0e-1f * reta * (reta + 1.0e1f) - 1.0f;
    p3 = (pp1 - pp2) * dd2;
    b3 = e12 * (0.5f * d2 * eta2d - eta3d * eta2d2 * dak2 + be3) * dd4;
    a3 = e24 * (eta22 * dak2 - 0.5f * d2 - al3) * dd4;
    um6 = t3 * a3 - e12 * v3 * v3;
    um5 = t1 * a3 + a1 * t3 - e24 * v1 * v3;
    um4 = t1 * a1 - e12 * v1 * v1;
    al6 = e12 * p3 * p3;
    al5 = e24 * p1 * p3 - b3 - b3 - ak2;
    al4 = e12 * p1 * p1 - b1 - b1;
    w56 = um5 * al6 - al5 * um6;
    w46 = um4 * al6 - al4 * um6;
    fa = -w46 / w56;
    ca = -fa;
    gMSAWave[hook(15, 3)] = fa;
    gMSAWave[hook(15, 2)] = ca;
    gMSAWave[hook(15, 1)] = b1 + b3 * fa;
    gMSAWave[hook(15, 0)] = a1 + a3 * fa;
    gMSAWave[hook(15, 8)] = v1 + v3 * fa;
    gMSAWave[hook(15, 14)] = -(p1 + p3 * fa);
    gMSAWave[hook(15, 15)] = gMSAWave[hook(15, 14)];
    if (fabs(gMSAWave[hook(15, 15)]) < 1.0e-3f) {
      gMSAWave[hook(15, 15)] = 0.0f;
    }
    gMSAWave[hook(15, 10)] = gMSAWave[hook(15, 16)];

  } else {
    t2 = ta4 * a2 + ta5 * b2 + e12 * (ta1 * ck - ta2 * sk);
    t3 = ta4 * a3 + ta5 * b3 + e12 * (ta1 * sk - ta2 * (ck - 1.0f)) - 4.0e-1f * reta * (reta + 1.0e1f) - 1.0f;

    um1 = t2 * a2 - e12 * v2 * v2;
    um2 = t1 * a2 + t2 * a1 - e24 * v1 * v2;
    um3 = t2 * a3 + t3 * a2 - e24 * v2 * v3;
    um4 = t1 * a1 - e12 * v1 * v1;
    um5 = t1 * a3 + t3 * a1 - e24 * v1 * v3;
    um6 = t3 * a3 - e12 * v3 * v3;

    if ((ix == 1) || (ix == 3)) {
      al1 = e12 * p2 * p2;
      al2 = e24 * p1 * p2 - b2 - b2;
      al3 = e24 * p2 * p3;
      al4 = e12 * p1 * p1 - b1 - b1;
      al5 = e24 * p1 * p3 - b3 - b3 - ak2;
      al6 = e12 * p3 * p3;

      w16 = um1 * al6 - al1 * um6;
      w15 = um1 * al5 - al1 * um5;
      w14 = um1 * al4 - al1 * um4;
      w13 = um1 * al3 - al1 * um3;
      w12 = um1 * al2 - al1 * um2;

      w26 = um2 * al6 - al2 * um6;
      w25 = um2 * al5 - al2 * um5;
      w24 = um2 * al4 - al2 * um4;

      w36 = um3 * al6 - al3 * um6;
      w35 = um3 * al5 - al3 * um5;
      w34 = um3 * al4 - al3 * um4;
      w32 = um3 * al2 - al3 * um2;

      w46 = um4 * al6 - al4 * um6;
      w56 = um5 * al6 - al5 * um6;
      w3526 = w35 + w26;
      w3425 = w34 + w25;

      w4 = w16 * w16 - w13 * w36;
      w3 = 2.0f * w16 * w15 - w13 * w3526 - w12 * w36;
      w2 = w15 * w15 + 2.0f * w16 * w14 - w13 * w3425 - w12 * w3526;
      w1 = 2.0f * w15 * w14 - w13 * w24 - w12 * w3425;
      w0 = w14 * w14 - w12 * w24;

      if (ix == 1) {
        fap = (w14 - w34 - w46) / (w12 - w15 + w35 - w26 + w56 - w32);
      } else {
        gMSAWave[hook(15, 14)] = 0.5f * eta2d * dd2 * exp(-rgek);
        if ((gMSAWave[hook(15, 11)] <= 2.0f) && (gMSAWave[hook(15, 11)] >= 0.0f) && (gMSAWave[hook(15, 12)] <= 1.0f)) {
          e24g = e24 * rgek * exp(rak);
          pwk = sqrt(e24g);
          qpw = (1.0f - sqrt(1.0f + 2.0f * d2 * d * pwk / eta22)) * eta21 / d;
          gMSAWave[hook(15, 14)] = -qpw * qpw / e24 + 0.5f * eta2d * dd2;
        }
        pg = p1 + gMSAWave[hook(15, 14)];
        ca = ak2 * pg + 2.0f * (b3 * pg - b1 * p3) + e12 * gMSAWave[hook(15, 14)] * gMSAWave[hook(15, 14)] * p3;
        ca = -ca / (ak2 * p2 + 2.0f * (b3 * p2 - b2 * p3));
        fap = -(pg + p2 * ca) / p3;
      }

      ii = 0;
      do {
        ii = ii + 1;
        if (ii > itm) {
          ir = -2;
          return (ir);
        }
        fa = fap;
        fun = w0 + (w1 + (w2 + (w3 + w4 * fa) * fa) * fa) * fa;
        fund = w1 + (2.0f * w2 + (3.0f * w3 + 4.0f * w4 * fa) * fa) * fa;
        fap = fa - fun / fund;
        del = fabs((fap - fa) / fa);
      } while (del > acc);

      ir = ir + ii;
      fa = fap;
      ca = -(w16 * fa * fa + w15 * fa + w14) / (w13 * fa + w12);
      gMSAWave[hook(15, 14)] = -(p1 + p2 * ca + p3 * fa);
      gMSAWave[hook(15, 15)] = gMSAWave[hook(15, 14)];
      if (fabs(gMSAWave[hook(15, 15)]) < 1.0e-3f) {
        gMSAWave[hook(15, 15)] = 0.0f;
      }
      gMSAWave[hook(15, 10)] = gMSAWave[hook(15, 16)];
    } else {
      ca = ak2 * p1 + 2.0f * (b3 * p1 - b1 * p3);
      ca = -ca / (ak2 * p2 + 2.0f * (b3 * p2 - b2 * p3));
      fa = -(p1 + p2 * ca) / p3;
      if (ix == 2) {
        gMSAWave[hook(15, 15)] = um1 * ca * ca + (um2 + um3 * fa) * ca + um4 + um5 * fa + um6 * fa * fa;
      }
      if (ix == 4) {
        gMSAWave[hook(15, 15)] = -(p1 + p2 * ca + p3 * fa);
      }
    }
    gMSAWave[hook(15, 3)] = fa;
    gMSAWave[hook(15, 2)] = ca;
    gMSAWave[hook(15, 1)] = b1 + b2 * ca + b3 * fa;
    gMSAWave[hook(15, 0)] = a1 + a2 * ca + a3 * fa;
    gMSAWave[hook(15, 8)] = (v1 + v2 * ca + v3 * fa) / gMSAWave[hook(15, 0)];
  }
  g24 = e24 * rgek * ex1;
  gMSAWave[hook(15, 7)] = (rak * ak2 * ca - g24) / (ak2 * g24);
  return (ir);
}

float sqhcal(float qq, float gMSAWave[]) {
  float SofQ, etaz, akz, gekz, e24, x1, x2, ck, sk, ak2, qk, q2k, qk2, qk3, qqk, sink, cosk, asink, qcosk, aqk, inter;

  etaz = gMSAWave[hook(15, 10)];
  akz = gMSAWave[hook(15, 12)];
  gekz = gMSAWave[hook(15, 11)];
  e24 = 24.0f * etaz;
  x1 = exp(akz);
  x2 = 0.0f;
  if (gMSAWave[hook(15, 12)] < 20.0f) {
    x2 = exp(-akz);
  }
  ck = 0.5f * (x1 + x2);
  sk = 0.5f * (x1 - x2);
  ak2 = akz * akz;

  if (qq <= 0.0f) {
    SofQ = -1.0f / gMSAWave[hook(15, 0)];
  } else {
    qk = qq / gMSAWave[hook(15, 13)];
    q2k = qk * qk;
    qk2 = 1.0f / q2k;
    qk3 = qk2 / qk;
    qqk = 1.0f / (qk * (q2k + ak2));
    sink = sin(qk);
    cosk = cos(qk);
    asink = akz * sink;
    qcosk = qk * cosk;
    aqk = gMSAWave[hook(15, 0)] * (sink - qcosk);
    aqk = aqk + gMSAWave[hook(15, 1)] * ((2.0f * qk2 - 1.0f) * qcosk + 2.0f * sink - 2.0f / qk);
    inter = 24.0f * qk3 + 4.0f * (1.0f - 6.0f * qk2) * sink;
    aqk = (aqk + 0.5f * etaz * gMSAWave[hook(15, 0)] * (inter - (1.0f - 12.0f * qk2 + 24.0f * qk2 * qk2) * qcosk)) * qk3;
    aqk = aqk + gMSAWave[hook(15, 2)] * (ck * asink - sk * qcosk) * qqk;
    aqk = aqk + gMSAWave[hook(15, 3)] * (sk * asink - qk * (ck * cosk - 1.0f)) * qqk;
    aqk = aqk + gMSAWave[hook(15, 3)] * (cosk - 1.0f) * qk2;
    aqk = aqk - gekz * (asink + qcosk) * qqk;
    SofQ = 1.0f / (1.0f - e24 * aqk);
  }
  return (SofQ);
}

float form_volume(float effect_radius);
float form_volume(float effect_radius) {
  return 1.0f;
}

float Iqxy(float qx, float qy, float effect_radius, float charge, float volfraction, float temperature, float saltconc, float dielectconst);
float Iqxy(float qx, float qy, float effect_radius, float charge, float volfraction, float temperature, float saltconc, float dielectconst) {
  return Iq(sqrt(qx * qx + qy * qy), effect_radius, charge, volfraction, temperature, saltconc, dielectconst);
}
kernel void HayterMSAsq_Iqxy(global const float* qx, global const float* qy, global float* result, const int Nq,

                             global float* loops_g,

                             local float* loops, const float cutoff, const int Neffect_radius,

                             const float scale, const float background, const float charge, const float volfraction, const float temperature, const float saltconc, const float dielectconst) {
  event_t e = async_work_group_copy(loops, loops_g, (Neffect_radius)*2, 0);
  wait_group_events(1, &e);

  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qxi = qx[hook(0, i)];
    const float qyi = qy[hook(1, i)];

    float ret = 0.0f, norm = 0.0f;

    float vol = 0.0f, norm_vol = 0.0f;

    for (int effect_radius_i = 0; effect_radius_i < Neffect_radius; effect_radius_i++) {
      const float effect_radius = loops[hook(5, 2 * (effect_radius_i))];
      const float effect_radius_w = loops[hook(5, 2 * (effect_radius_i) + 1)];

      const float weight = effect_radius_w;
      if (weight > cutoff) {
        const float scattering = Iqxy(qxi, qyi, effect_radius, charge, volfraction, temperature, saltconc, dielectconst);
        if (!isnan(scattering)) {
          const float next = weight * scattering;

          ret += next;

          norm += weight;

          const float vol_weight = effect_radius_w;
          vol += vol_weight * form_volume(effect_radius);

          norm_vol += vol_weight;
        }
      }
    }

    if (vol * norm_vol != 0.0f) {
      ret *= norm_vol / vol;
    }

    result[hook(2, i)] = scale * ret / norm + background;
  }
}