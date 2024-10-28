//{"a":0,"b":1,"n":3,"x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int matrix_print_off(int nr, int nc, double* A);
int vector_print_off(int nr, double* x);
kernel void gauss(global double* restrict a, global double* restrict b, global double* restrict x, int n) {
  int i, j, k, m, rowx;
  double xfac, temp, temp1, amax;
  rowx = 0;
  for (k = 0; k < n - 1; ++k) {
    amax = (double)fabs(a[hook(0, k * n + k)]);
    m = k;
    for (i = k + 1; i < n; i++) {
      xfac = (double)fabs(a[hook(0, i * n + k)]);
      if (xfac > amax) {
        amax = xfac;
        m = i;
      }
    }
    if (m != k) {
      rowx = rowx + 1;
      temp1 = b[hook(1, k)];
      b[hook(1, k)] = b[hook(1, m)];
      b[hook(1, m)] = temp1;
      for (j = k; j < n; j++) {
        temp = a[hook(0, k * n + j)];
        a[hook(0, k * n + j)] = a[hook(0, m * n + j)];
        a[hook(0, m * n + j)] = temp;
      }
    }

    for (i = k + 1; i < n; ++i) {
      xfac = a[hook(0, i * n + k)] / a[hook(0, k * n + k)];

      for (j = k + 1; j < n; ++j) {
        a[hook(0, i * n + j)] = a[hook(0, i * n + j)] - xfac * a[hook(0, k * n + j)];
      }
      b[hook(1, i)] = b[hook(1, i)] - xfac * b[hook(1, k)];
    }
  }

  for (j = 0; j < n; ++j) {
    k = n - 1 - j;
    x[hook(2, k)] = b[hook(1, k)];
    for (i = k + 1; i < n; ++i) {
      x[hook(2, k)] = x[hook(2, k)] - a[hook(0, k * n + i)] * x[hook(2, i)];
    }
    x[hook(2, k)] = x[hook(2, k)] / a[hook(0, k * n + k)];
  }
}