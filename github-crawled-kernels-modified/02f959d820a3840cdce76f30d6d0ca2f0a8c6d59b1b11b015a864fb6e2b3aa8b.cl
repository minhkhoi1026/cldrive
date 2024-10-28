//{"a":0,"b":1,"c":2,"col":4,"com":5,"d":3,"offsetac":7,"offsetar":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mul(global double* a, global double* b, global double* c, global double* d, unsigned long col, unsigned char com, unsigned long offsetar, unsigned long offsetac) {
  unsigned long i = get_global_id(0);

  double aa, bb, cc, dd;
  unsigned long ee;
  if (com) {
    for (unsigned long j = 0; j < col; j++) {
      ee = (i + offsetar) * col + j + offsetac;
      aa = a[hook(0, ee)];
      bb = b[hook(1, ee)];
      cc = c[hook(2, i)];
      dd = d[hook(3, i)];
      c[hook(2, i)] = aa * cc - bb * dd;
      d[hook(3, i)] = aa * dd + bb * cc;
    }
  } else {
    for (unsigned long j = 0; j < col; j++) {
      c[hook(2, i)] *= a[hook(0, i * col + j)];
    }
  }
}