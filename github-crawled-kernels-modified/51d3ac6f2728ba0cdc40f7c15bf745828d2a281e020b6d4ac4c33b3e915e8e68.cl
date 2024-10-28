//{"a":0,"b":1,"col":2,"com":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void complex_mul(global double* a, global double* b, double c, double d) {
  double e, f;
  e = a[hook(0, 0)] * c - b[hook(1, 0)] * d;
  f = a[hook(0, 0)] * d + b[hook(1, 0)] * c;
  a[hook(0, 0)] = e;
  b[hook(1, 0)] = f;
}

void calc_inv_complex(double* a, double* b) {
  double c, d;
  c = a[hook(0, 0)] / (a[hook(0, 0)] * a[hook(0, 0)] + b[hook(1, 0)] * b[hook(1, 0)]);
  d = -1.0 * b[hook(1, 0)] / (a[hook(0, 0)] * a[hook(0, 0)] + b[hook(1, 0)] * b[hook(1, 0)]);
  a[hook(0, 0)] = c;
  b[hook(1, 0)] = d;
}

kernel void logsig(global double* a, global double* b, unsigned long col, unsigned char com) {
  unsigned long i = get_global_id(0) * col + get_global_id(1);

  double c, d;
  c = exp(-1.0 * a[hook(0, i)]);

  if (com) {
    d = c * sin(b[hook(1, i)]);
    c *= cos(b[hook(1, i)]);

    a[hook(0, i)] = c;
    b[hook(1, i)] = d;
    c += 1.0;

    calc_inv_complex(&c, &d);
    complex_mul(&a[hook(0, i)], &b[hook(1, i)], c, d);
  } else {
    a[hook(0, i)] = 1.0 / (c + 1.0);
  }
}