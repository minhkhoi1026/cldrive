//{"a":5,"alpha":4,"b":7,"beta":9,"c":10,"lda":6,"ldb":8,"ldc":11,"m":2,"n":3,"side":0,"uplo":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Ssymm_naive(int side, int uplo, int m, int n, float alpha, global float* a, int lda, global float* b, int ldb, float beta, global float* c, int ldc) {
  bool leftside = side == 0;
  bool ltriangle = uplo == 1;

  int ind_m = get_global_id(0);
  int ind_n = get_global_id(1);

  if (ltriangle) {
    if (leftside) {
      float value = 0.f;
      for (int i = 0; i < m; i++) {
        if (i > ind_m) {
          value += a[hook(5, (ind_m) * (lda) + (i))] * b[hook(7, (ind_n) * (ldb) + (i))];
        } else {
          value += a[hook(5, (i) * (lda) + (ind_m))] * b[hook(7, (ind_n) * (ldb) + (i))];
        }
      }
      value *= alpha;
      c[hook(10, (ind_n) * (ldc) + (ind_m))] = beta * c[hook(10, (ind_n) * (ldc) + (ind_m))] + value;
    } else {
      float value = 0.f;
      for (int i = 0; i < n; i++) {
        if (i < ind_n) {
          value += a[hook(5, (i) * (lda) + (ind_n))] * b[hook(7, (i) * (ldb) + (ind_m))];
        } else {
          value += a[hook(5, (ind_n) * (lda) + (i))] * b[hook(7, (i) * (ldb) + (ind_m))];
        }
      }
      value *= alpha;
      c[hook(10, (ind_n) * (ldc) + (ind_m))] = beta * c[hook(10, (ind_n) * (ldc) + (ind_m))] + value;
    }
  } else {
    if (leftside) {
      float value = 0.f;
      for (int i = 0; i < m; i++) {
        if (i < ind_m) {
          value += a[hook(5, (ind_m) * (lda) + (i))] * b[hook(7, (ind_n) * (ldb) + (i))];
        } else {
          value += a[hook(5, (i) * (lda) + (ind_m))] * b[hook(7, (ind_n) * (ldb) + (i))];
        }
      }
      value *= alpha;
      c[hook(10, (ind_n) * (ldc) + (ind_m))] = beta * c[hook(10, (ind_n) * (ldc) + (ind_m))] + value;
    } else {
      float value = 0.f;
      for (int i = 0; i < n; i++) {
        if (i > ind_n) {
          value += a[hook(5, (i) * (lda) + (ind_n))] * b[hook(7, (i) * (ldb) + (ind_m))];
        } else {
          value += a[hook(5, (ind_n) * (lda) + (i))] * b[hook(7, (i) * (ldb) + (ind_m))];
        }
      }
      value *= alpha;
      c[hook(10, (ind_n) * (ldc) + (ind_m))] = beta * c[hook(10, (ind_n) * (ldc) + (ind_m))] + value;
    }
  }
}