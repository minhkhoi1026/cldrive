//{"a":0,"b":1,"c":2,"col":5,"com":6,"d":3,"k":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void gauss_real(global double* a, global double* b, unsigned long k, unsigned long i, unsigned long col) {
  if (isnotequal(a[hook(0, i * col + k)], 0.0)) {
    double aa = a[hook(0, k * col + k)] / a[hook(0, i * col + k)], bb;
    b[hook(1, i * col + k)] /= aa;
    for (unsigned long j = k; j < col; j++) {
      bb = a[hook(0, i * col + j)];
      bb *= aa;
      bb -= a[hook(0, k * col + j)];
      a[hook(0, i * col + j)] = bb;
    }
  }
}

void gauss_com(global double* a, global double* b, global double* c, global double* d, unsigned long k, unsigned long i, unsigned long col) {
  double aa, bb, cc, dd, akk, bkk, akj, bkj;
  aa = a[hook(0, i * col + k)];
  bb = b[hook(1, i * col + k)];
  if (aa != 0.0 || bb != 0.0) {
    for (unsigned long j = k; j < col; j++) {
      cc = a[hook(0, i * col + j)];
      dd = b[hook(1, i * col + j)];
      akk = a[hook(0, k * col + k)];
      bkk = b[hook(1, k * col + k)];
      akj = a[hook(0, k * col + j)];
      bkj = b[hook(1, k * col + j)];

      a[hook(0, i * col + j)] = (cc * akk - dd * bkk) - (akj * aa - bkj * bb);
      b[hook(1, i * col + j)] = (cc * bkk + dd * akk) - (akj * bb + bkj * aa);
    }
  }
}

kernel void det(global double* a, global double* b, global double* c, global double* d, unsigned long k, unsigned long col, unsigned char com) {
  unsigned long i = get_global_id(0);

  c[hook(2, k * col + k)] = a[hook(0, k * col + k)];
  if (i > k) {
    if (com) {
      gauss_com(a, b, c, d, k, i, col);
      d[hook(3, k * col + k)] = b[hook(1, k * col + k)];
    } else {
      gauss_real(a, c, k, i, col);
    }
  }
}