//{"a":0,"b":1,"c":2,"col":7,"col2":8,"com":9,"d":3,"ik":5,"k":4,"klen":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conv1d(global double* a, global double* b, global double* c, global double* d, global double* k, global double* ik, unsigned long klen, unsigned long col, unsigned long col2, unsigned char com) {
  unsigned long i = get_global_id(0);
  unsigned long j = get_global_id(1);
  double ra = k[hook(4, klen)], rb, aa, bb, cc, dd;
  if (com) {
    rb = ik[hook(5, klen)];
    for (unsigned long h = 0; h < klen; h++) {
      aa = c[hook(2, i * col2 + j + h)];
      bb = d[hook(3, i * col2 + j + h)];
      cc = k[hook(4, h)];
      dd = ik[hook(5, h)];
      ra += aa * cc - bb * cc;
      rb += aa * dd + bb * cc;
    }
    b[hook(1, i * col + j)] = rb;
  } else {
    for (unsigned long h = 0; h < klen; h++) {
      ra += c[hook(2, i * col2 + j + h)] * k[hook(4, h)];
    }
  }
  a[hook(0, i * col + j)] = ra;
}