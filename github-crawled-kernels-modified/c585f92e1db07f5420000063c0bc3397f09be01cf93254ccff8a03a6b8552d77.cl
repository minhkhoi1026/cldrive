//{"a":0,"alpha":5,"b":1,"beta":6,"c":2,"col":7,"col2":8,"com":4,"d":3,"offsetac":10,"offsetar":9,"offsetbc":12,"offsetbr":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void axpy(global double* a, global double* b, global double* c, global double* d, unsigned char com, double alpha, double beta, unsigned long col, unsigned long col2, unsigned long offsetar, unsigned long offsetac, unsigned long offsetbr, unsigned long offsetbc) {
  unsigned long i = get_global_id(0);
  unsigned long j = get_global_id(1);

  double aa, bb, cc, dd;
  if (com) {
    aa = a[hook(0, (i + offsetar) * col + j + offsetac)];
    bb = b[hook(1, (i + offsetar) * col + j + offsetac)];
    cc = c[hook(2, (i + offsetbr) * col2 + j + offsetbc)];
    dd = d[hook(3, (i + offsetbr) * col2 + j + offsetbc)];

    c[hook(2, (i + offsetbr) * col2 + j + offsetbc)] = alpha * aa - beta * bb + cc;
    d[hook(3, (i + offsetbr) * col2 + j + offsetbc)] = alpha * bb + beta * aa + dd;
  } else {
    c[hook(2, (i + offsetbr) * col2 + j + offsetbc)] += alpha * a[hook(0, (i + offsetar) * col + j + offsetac)];
  }
}