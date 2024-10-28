//{"a":0,"b":1,"c":2,"col":4,"com":5,"d":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void calc_coeff(double a, double b, global double* c, global double* d) {
  double r, ang, cc, dd;
  cc = c[hook(2, 0)];
  dd = d[hook(3, 0)];

  r = a / (a * a + b * b);
  ang = -1.0 * b / (a * a + b * b);

  a = cc * r - dd * ang;
  b = cc * ang + dd * r;

  c[hook(2, 0)] = a;
  d[hook(3, 0)] = b;
}

kernel void gauss2(global double* a, global double* b, global double* c, global double* d, unsigned long col, unsigned char com) {
  unsigned long i = get_global_id(0);
  unsigned long j = get_global_id(1);

  double cc, dd;
  if (com) {
    calc_coeff(a[hook(0, i * col + i)], b[hook(1, i * col + i)], &c[hook(2, i * col + j)], &d[hook(3, i * col + j)]);
  } else {
    c[hook(2, i * col + j)] /= a[hook(0, i * col + i)];
  }
}