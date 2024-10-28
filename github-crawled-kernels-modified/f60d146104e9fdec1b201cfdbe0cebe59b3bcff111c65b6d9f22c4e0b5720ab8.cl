//{"a":0,"b":1,"c":2,"col":5,"com":6,"d":3,"k":4,"otherm":7,"t":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void gauss_real(global double* a, global double* b, unsigned long k, unsigned long i, unsigned long col, unsigned char otherm) {
  if (isnotequal(a[hook(0, i * col + i)], 0.0) && !isnan(a[hook(0, i * col + i)])) {
    if (isnotequal(a[hook(0, i * col + k)], 0.0)) {
      double aa = a[hook(0, k * col + k)] / a[hook(0, i * col + k)], bb;
      for (unsigned long j = 0; j < col; j++) {
        bb = a[hook(0, i * col + j)];
        bb *= aa;
        bb -= a[hook(0, k * col + j)];
        a[hook(0, i * col + j)] = bb;
        if (otherm) {
          bb = b[hook(1, i * col + j)];
          bb *= aa;
          bb -= b[hook(1, k * col + j)];
          b[hook(1, i * col + j)] = bb;
        }
      }
    }
  }
}

void calc_coeff(double a, double b, double* c, double* d) {
  double r, ang;

  r = a / (a * a + b * b);
  ang = -1.0 * b / (a * a + b * b);

  a = c[hook(2, 0)] * r - d[hook(3, 0)] * ang;
  b = c[hook(2, 0)] * ang + d[hook(3, 0)] * r;

  c[hook(2, 0)] = a;
  d[hook(3, 0)] = b;
}

void gauss_com(global double* a, global double* b, global double* c, global double* d, unsigned long k, unsigned long i, unsigned long col, unsigned char otherm) {
  double aa, bb, cc, dd;
  aa = a[hook(0, i * col + i)];
  bb = b[hook(1, i * col + i)];
  if ((isnotequal(aa, 0.0) && !isnan(aa)) || (isnotequal(bb, 0.0) && !isnan(bb))) {
    if (isnotequal(a[hook(0, i * col + k)], 0.0) || isnotequal(b[hook(1, i * col + k)], 0.0)) {
      aa = a[hook(0, k * col + k)];
      bb = b[hook(1, k * col + k)];
      calc_coeff(a[hook(0, i * col + k)], b[hook(1, i * col + k)], &aa, &bb);
      for (unsigned long j = 0; j < col; j++) {
        cc = a[hook(0, i * col + j)];
        dd = b[hook(1, i * col + j)];
        a[hook(0, i * col + j)] = (cc * aa - dd * bb) - a[hook(0, k * col + j)];
        b[hook(1, i * col + j)] = (cc * bb + dd * aa) - b[hook(1, k * col + j)];
        if (otherm) {
          cc = c[hook(2, i * col + j)];
          dd = d[hook(3, i * col + j)];
          c[hook(2, i * col + j)] = (cc * aa - dd * bb) - c[hook(2, k * col + j)];
          d[hook(3, i * col + j)] = (cc * bb + dd * aa) - d[hook(3, k * col + j)];
        }
      }
    }
  }
}

kernel void gauss(global double* a, global double* b, global double* c, global double* d, unsigned long k, unsigned long col, unsigned char com, unsigned char otherm, unsigned char t) {
  unsigned long i = get_global_id(0);

  if (t) {
    i = col - i - 1;
    k = col - k - 1;
  }

  if ((i > k && t == 0) || (i < k && t)) {
    if (com) {
      gauss_com(a, b, c, d, k, i, col, otherm);
    } else {
      gauss_real(a, c, k, i, col, otherm);
    }
  }
}