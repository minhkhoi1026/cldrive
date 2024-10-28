//{"a":5,"alpha":4,"b":7,"beta":9,"c":10,"k":3,"lda":6,"ldb":8,"ldc":11,"n":2,"trans":1,"uplo":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Ssyr2k_naive(int uplo, int trans, int n, int k, float alpha, global float* a, int lda, global float* b, int ldb, float beta, global float* c, int ldc) {
  bool ltriangle = uplo == 1;
  bool ntrans = trans == 0;

  int ind_m = get_global_id(0);
  int ind_n = get_global_id(1);

  bool upper = ind_m < ind_n;
  bool lower = ind_m > ind_n;

  if (ltriangle && upper)
    return;
  if (!ltriangle && lower)
    return;

  float value = 0.f;

  if (ntrans) {
    for (int i = 0; i < k; i++) {
      value += a[hook(5, (i) * (lda) + (ind_m))] * b[hook(7, (i) * (ldb) + (ind_n))];
      value += b[hook(7, (i) * (ldb) + (ind_m))] * a[hook(5, (i) * (lda) + (ind_n))];
    }
  } else {
    for (int i = 0; i < k; i++) {
      value += a[hook(5, (ind_m) * (lda) + (i))] * b[hook(7, (ind_n) * (ldb) + (i))];
      value += b[hook(7, (ind_m) * (ldb) + (i))] * a[hook(5, (ind_n) * (lda) + (i))];
    }
  }

  value *= alpha;
  c[hook(10, (ind_n) * (ldc) + (ind_m))] = beta * c[hook(10, (ind_n) * (ldc) + (ind_m))] + value;
}