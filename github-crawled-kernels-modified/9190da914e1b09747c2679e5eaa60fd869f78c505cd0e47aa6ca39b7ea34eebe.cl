//{"a":0,"b":1,"c":2,"col":5,"col2":6,"com":4,"d":3,"offsetac":8,"offsetar":7,"offsetbc":10,"offsetbr":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void complex_mul(global double* a, global double* b, double c, double d) {
  double e, f, g, h;
  g = a[hook(0, 0)];
  h = b[hook(1, 0)];
  e = g * c - h * d;
  f = g * d + h * c;
  a[hook(0, 0)] = e;
  b[hook(1, 0)] = f;
}

void calc_inv_complex(double* a, double* b) {
  double c, d, aa, bb;
  aa = a[hook(0, 0)];
  bb = b[hook(1, 0)];
  c = aa / (aa * aa + bb * bb);
  d = -1.0 * bb / (aa * aa + bb * bb);
  a[hook(0, 0)] = c;
  b[hook(1, 0)] = d;
}

kernel void divide(global double* a, global double* b, global double* c, global double* d, unsigned char com, unsigned long col, unsigned long col2, unsigned long offsetar, unsigned long offsetac, unsigned long offsetbr, unsigned long offsetbc) {
  unsigned long i = get_global_id(0);
  unsigned long j = get_global_id(1);

  double aa, bb;
  if (com) {
    aa = c[hook(2, (i + offsetbr) * col2 + j + offsetbc)];
    bb = d[hook(3, (i + offsetbr) * col2 + j + offsetbc)];
    calc_inv_complex(&aa, &bb);
    complex_mul(&a[hook(0, (i + offsetar) * col + j + offsetac)], &b[hook(1, (i + offsetar) * col + j + offsetac)], aa, bb);
  } else {
    a[hook(0, (i + offsetar) * col + j + offsetac)] /= c[hook(2, (i + offsetbr) * col2 + j + offsetbc)];
  }
}