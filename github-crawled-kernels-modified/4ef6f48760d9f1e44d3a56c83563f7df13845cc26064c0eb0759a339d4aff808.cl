//{"a":0,"b":1,"col":6,"com":7,"ia":3,"ie":5,"ra":2,"re":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void uniform(global double* a, global double* b, double ra, double ia, double re, double ie, unsigned long col, unsigned char com) {
  unsigned long i = get_global_id(0);
  unsigned long j = get_global_id(1);

  double aa, bb, cc, dd;
  if (com) {
    aa = a[hook(0, i * col + j)];
    bb = b[hook(1, i * col + j)];
    cc = re - ra;
    dd = ie - ia;
    a[hook(0, i * col + j)] = ra + aa * cc - bb * dd;
    b[hook(1, i * col + j)] = re + aa * dd + bb * cc;
  } else {
    a[hook(0, i * col + j)] = ra + (re - ra) * a[hook(0, i * col + j)];
  }
}