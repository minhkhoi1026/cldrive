//{"a":0,"alpha":2,"b":1,"beta":3,"com":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void complex_mul(double* a, double* b, double c, double d) {
  double e, f, g, h;
  g = a[hook(0, 0)];
  h = b[hook(1, 0)];
  e = g * c - h * d;
  f = g * d + h * c;
  a[hook(0, 0)] = e;
  b[hook(1, 0)] = f;
}

void step_one(double* a, double* b, double r, double h, double y) {
  double c = cosh(h) - sinh(h);
  a[hook(0, 0)] = cos(y * r) * c;
  b[hook(1, 0)] = sin(y * r) * c;
}

void step_two(double* a, double* b, double h, double r, double x) {
  double er, co, si, mwo, awo;
  er = exp(r);
  co = cos(h) * er;
  si = sin(h) * er;

  awo = atan2(si, co);
  mwo = pow(sqrt(co * co + si * si), x);
  a[hook(0, 0)] = mwo * cos(awo * x);
  b[hook(1, 0)] = mwo * sin(awo * x);
}

kernel void power(global double* a, global double* b, double alpha, double beta, unsigned char com) {
  unsigned long i = get_global_id(0);
  unsigned long j = get_global_id(1);
  unsigned long col = get_global_size(1);
  double aa, bb, r, h, so, soi;

  unsigned long current = i * col + j;

  if (com) {
    aa = a[hook(0, current)];
    bb = b[hook(1, current)];
    r = 0.5 * log(aa * aa + bb * bb);
    h = atan2(bb, aa);

    step_one(&so, &soi, r, h, beta);
    step_two(&aa, &bb, r, h, alpha);

    complex_mul(&aa, &bb, so, soi);

    a[hook(0, current)] = aa;
    b[hook(1, current)] = bb;
  } else {
    a[hook(0, current)] = pow(a[hook(0, current)], alpha);
  }
}