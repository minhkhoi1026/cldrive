//{"a":7,"b":8,"col":6,"idev":5,"ipoly":3,"iroot":1,"rdev":4,"rpoly":2,"rroot":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void complex_mul(double* a, double* b, double c, double d) {
  double e, f, g, h;
  g = a[hook(7, 0)];
  h = b[hook(8, 0)];
  e = g * c - h * d;
  f = g * d + h * c;
  a[hook(7, 0)] = e;
  b[hook(8, 0)] = f;
}

void calc_poly(double r, double i, double* a, double* b, global double* rpoly, global double* ipoly, unsigned long col) {
  a[hook(7, 0)] = 0.0;
  b[hook(8, 0)] = 0.0;
  double c = 1.0, d = 0.0, aa = 0.0, bb = 0.0;
  for (unsigned long x = 0; x < col; x++) {
    aa += rpoly[hook(2, x)] * c - ipoly[hook(3, x)] * d;
    bb += rpoly[hook(2, x)] * d + ipoly[hook(3, x)] * c;
    complex_mul(&c, &d, r, i);
  }
  a[hook(7, 0)] = aa;
  b[hook(8, 0)] = bb;
}

void calc_inv_complex(double* a, double* b) {
  double c, d, aa, bb;
  aa = a[hook(7, 0)];
  bb = b[hook(8, 0)];
  c = aa / (aa * aa + bb * bb);
  d = -1.0 * bb / (aa * aa + bb * bb);
  a[hook(7, 0)] = c;
  b[hook(8, 0)] = d;
}

void calc_ratio(double r, double i, double* fr, double* fi, global double* rpoly, global double* ipoly, global double* rdev, global double* idev, unsigned long col) {
  double dr, di;

  calc_poly(r, i, fr, fi, rpoly, ipoly, col + 1);
  calc_poly(r, i, &dr, &di, rdev, idev, col);

  calc_inv_complex(&dr, &di);

  complex_mul(fr, fi, dr, di);
}

kernel void aberth(global double* rroot, global double* iroot, global double* rpoly, global double* ipoly, global double* rdev, global double* idev, unsigned long col) {
  unsigned long i = get_global_id(0);

  double ratior, ratioi, devr, devi;
  double ro, io, error = 0x1.fffffffffffffp1023;

  while (error > 1e-14) {
    calc_ratio(rroot[hook(0, i)], iroot[hook(1, i)], &ratior, &ratioi, rpoly, ipoly, rdev, idev, col);

    devr = 0.0;
    devi = 0.0;
    for (unsigned long x = 0; x < col; x++) {
      if (x != i) {
        ro = rroot[hook(0, i)];
        io = iroot[hook(1, i)];
        ro -= rroot[hook(0, x)];
        io -= iroot[hook(1, x)];

        calc_inv_complex(&ro, &io);
        devr += ro;
        devi += io;
      }
    }

    complex_mul(&devr, &devi, ratior, ratioi);
    devr = 1.0 - devr;
    devi *= -1.0;
    calc_inv_complex(&devr, &devi);
    complex_mul(&ratior, &ratioi, devr, devi);

    rroot[hook(0, i)] -= ratior;
    iroot[hook(1, i)] -= ratioi;

    error = sqrt(ratior * ratior + ratioi * ratioi);
  }
}