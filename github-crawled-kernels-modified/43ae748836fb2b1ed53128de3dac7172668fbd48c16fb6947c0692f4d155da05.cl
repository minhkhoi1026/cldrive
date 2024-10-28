//{"a_trans":6,"ai":1,"ar":0,"b_trans":7,"bi":3,"br":2,"ci":5,"col":12,"col2":14,"col3":23,"com":22,"cr":4,"ialpha":9,"ibeta":11,"offsetac":17,"offsetar":16,"offsetbc":19,"offsetbr":18,"offsetcc":21,"offsetcr":20,"ralpha":8,"rbeta":10,"rcol":13,"row":15}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gemm(global double* ar, global double* ai, global double* br, global double* bi, global double* cr, global double* ci, unsigned char a_trans, unsigned char b_trans, double ralpha, double ialpha, double rbeta, double ibeta, unsigned long col, unsigned long rcol, unsigned long col2, unsigned long row, unsigned long offsetar, unsigned long offsetac, unsigned long offsetbr, unsigned long offsetbc, unsigned long offsetcr, unsigned long offsetcc, unsigned char com, unsigned long col3) {
  unsigned long i = get_global_id(0);
  unsigned long k = get_global_id(1);
  unsigned ccurr = (i + offsetcr) * col3 + k + offsetcc;

  double ra = 0.0, rb = 0.0;
  double aa, bb, cc, dd;

  if (com) {
    if (a_trans && b_trans) {
      for (unsigned long j = 0; j < row; j++) {
        aa = ar[hook(0, (j + offsetar) * col + i + offsetac)];
        bb = ai[hook(1, (j + offsetar) * col + i + offsetac)];
        cc = br[hook(2, (k + offsetbr) * col2 + j + offsetbc)];
        dd = bi[hook(3, (k + offsetbr) * col2 + j + offsetbc)];

        ra += aa * cc - bb * dd;
        rb += aa * dd + bb * cc;
      }
    } else if (a_trans && b_trans == 0) {
      for (unsigned long j = 0; j < row; j++) {
        aa = ar[hook(0, (j + offsetar) * col + i + offsetac)];
        bb = ai[hook(1, (j + offsetar) * col + i + offsetac)];
        cc = br[hook(2, (j + offsetbr) * col2 + k + offsetbc)];
        dd = bi[hook(3, (j + offsetbr) * col2 + k + offsetbc)];

        ra += aa * cc - bb * dd;
        rb += aa * dd + bb * cc;
      }
    } else if (a_trans == 0 && b_trans) {
      for (unsigned long j = 0; j < col; j++) {
        aa = ar[hook(0, (i + offsetar) * col + j + offsetac)];
        bb = ai[hook(1, (i + offsetar) * col + j + offsetac)];
        cc = br[hook(2, (k + offsetbr) * col2 + j + offsetbc)];
        dd = bi[hook(3, (k + offsetbr) * col2 + j + offsetbc)];

        ra += aa * cc - bb * dd;
        rb += aa * dd + bb * cc;
      }
    } else if (a_trans == 0 && b_trans == 0) {
      for (unsigned long j = 0; j < col; j++) {
        aa = ar[hook(0, (i + offsetar) * col + j + offsetac)];
        bb = ai[hook(1, (i + offsetar) * col + j + offsetac)];
        cc = br[hook(2, (j + offsetbr) * col2 + k + offsetbc)];
        dd = bi[hook(3, (j + offsetbr) * col2 + k + offsetbc)];

        ra += aa * cc - bb * dd;
        rb += aa * dd + bb * cc;
      }
    }
    aa = cr[hook(4, ccurr)];
    bb = ci[hook(5, ccurr)];

    cr[hook(4, ccurr)] = ra * ralpha - rb * ialpha + aa * rbeta - bb * ibeta;
    ci[hook(5, ccurr)] = ra * ialpha + rb * ralpha + aa * ibeta + bb * rbeta;
  } else {
    if (a_trans && b_trans) {
      for (unsigned long j = 0; j < row; j++) {
        ra += ar[hook(0, (j + offsetar) * rcol + i + offsetac)] * br[hook(2, (k + offsetbr) * col2 + j + offsetbc)];
      }
    } else if (a_trans && b_trans == 0) {
      for (unsigned long j = 0; j < row; j++) {
        ra += ar[hook(0, (j + offsetar) * rcol + i + offsetac)] * br[hook(2, (j + offsetbr) * col2 + k + offsetbc)];
      }
    } else if (a_trans == 0 && b_trans) {
      for (unsigned long j = 0; j < col; j++) {
        ra += ar[hook(0, (i + offsetar) * rcol + j + offsetac)] * br[hook(2, (k + offsetbr) * col2 + j + offsetbc)];
      }
    } else {
      for (unsigned long j = 0; j < col; j++) {
        ra += ar[hook(0, (i + offsetar) * rcol + j + offsetac)] * br[hook(2, (j + offsetbr) * col2 + k + offsetbc)];
      }
    }
    cr[hook(4, ccurr)] = ra * ralpha + rbeta * cr[hook(4, ccurr)];
  }
}