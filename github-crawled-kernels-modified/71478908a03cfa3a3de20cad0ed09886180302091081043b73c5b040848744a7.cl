//{"a":7,"alpha":6,"b":9,"diag":3,"lda":8,"ldb":10,"m":4,"n":5,"side":0,"trans":2,"uplo":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Strsm_naive(int side, int uplo, int trans, int diag, int m, int n, float alpha, global float* a, int lda, global float* b, int ldb) {
  bool left = side == 0;
  bool ltriangle = uplo == 1;
  bool ntrans = trans == 0;
  bool ndiag = diag == 0;

  if (left) {
    if (ltriangle) {
      if (ntrans) {
        for (int i = 0; i < m; i++) {
          for (int j = 0; j < n; j++) {
            float this_x = b[hook(9, (j) * (ldb) + (i))];
            if (ndiag)
              this_x /= a[hook(7, (i) * (lda) + (i))];
            for (int k = i + 1; k < m; k++) {
              b[hook(9, (j) * (ldb) + (k))] -= a[hook(7, (i) * (lda) + (k))] * this_x;
            }
            b[hook(9, (j) * (ldb) + (i))] = this_x * alpha;
          }
        }
      } else {
        for (int i = m - 1; i >= 0; i--) {
          for (int j = 0; j < n; j++) {
            float this_x = b[hook(9, (j) * (ldb) + (i))];
            if (ndiag)
              this_x /= a[hook(7, (i) * (lda) + (i))];
            for (int k = 0; k < i; k++) {
              b[hook(9, (j) * (ldb) + (k))] -= a[hook(7, (k) * (lda) + (i))] * this_x;
            }
            b[hook(9, (j) * (ldb) + (i))] = this_x * alpha;
          }
        }
      }
    } else {
      if (ntrans) {
        for (int i = m - 1; i >= 0; i--) {
          for (int j = 0; j < n; j++) {
            float this_x = b[hook(9, (j) * (ldb) + (i))];
            if (ndiag)
              this_x /= a[hook(7, (i) * (lda) + (i))];
            for (int k = 0; k < i; k++) {
              b[hook(9, (j) * (ldb) + (k))] -= a[hook(7, (i) * (lda) + (k))] * this_x;
            }
            b[hook(9, (j) * (ldb) + (i))] = this_x * alpha;
          }
        }
      } else {
        for (int i = 0; i < m; i++) {
          for (int j = 0; j < n; j++) {
            float this_x = b[hook(9, (j) * (ldb) + (i))];
            if (ndiag)
              this_x /= a[hook(7, (i) * (lda) + (i))];
            for (int k = i + 1; k < m; k++) {
              b[hook(9, (j) * (ldb) + (k))] -= a[hook(7, (k) * (lda) + (i))] * this_x;
            }
            b[hook(9, (j) * (ldb) + (i))] = this_x * alpha;
          }
        }
      }
    }
  } else {
    if (ltriangle) {
      if (ntrans) {
        for (int i = n - 1; i >= 0; i--) {
          for (int j = 0; j < m; j++) {
            float this_x = b[hook(9, (i) * (ldb) + (j))];
            if (ndiag)
              this_x /= a[hook(7, (i) * (lda) + (i))];
            for (int k = 0; k < i; k++) {
              b[hook(9, (k) * (ldb) + (j))] -= a[hook(7, (k) * (lda) + (i))] * this_x;
            }
            b[hook(9, (i) * (ldb) + (j))] = this_x * alpha;
          }
        }
      } else {
        for (int i = 0; i < n; i++) {
          for (int j = 0; j < m; j++) {
            float this_x = b[hook(9, (i) * (ldb) + (j))];
            if (ndiag)
              this_x /= a[hook(7, (i) * (lda) + (i))];
            for (int k = i + 1; k < n; k++) {
              b[hook(9, (k) * (ldb) + (j))] -= a[hook(7, (i) * (lda) + (k))] * this_x;
            }
            b[hook(9, (i) * (ldb) + (j))] = this_x * alpha;
          }
        }
      }
    } else {
      if (ntrans) {
        for (int i = 0; i < n; i++) {
          for (int j = 0; j < m; j++) {
            float this_x = b[hook(9, (i) * (ldb) + (j))];
            if (ndiag)
              this_x /= a[hook(7, (i) * (lda) + (i))];
            for (int k = i + 1; k < n; k++) {
              b[hook(9, (k) * (ldb) + (j))] -= a[hook(7, (k) * (lda) + (i))] * this_x;
            }
            b[hook(9, (i) * (ldb) + (j))] = this_x * alpha;
          }
        }
      } else {
        for (int i = n - 1; i >= 0; i--) {
          for (int j = 0; j < m; j++) {
            float this_x = b[hook(9, (i) * (ldb) + (j))];
            if (ndiag)
              this_x /= a[hook(7, (i) * (lda) + (i))];
            for (int k = 0; k < i; k++) {
              b[hook(9, (k) * (ldb) + (j))] -= a[hook(7, (i) * (lda) + (k))] * this_x;
            }
            b[hook(9, (i) * (ldb) + (j))] = this_x * alpha;
          }
        }
      }
    }
  }
}