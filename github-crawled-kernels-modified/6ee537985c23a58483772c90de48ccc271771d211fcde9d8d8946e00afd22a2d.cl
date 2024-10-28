//{"A":0,"L":1,"n":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cholesky_decomp(global float* restrict A, global float* restrict L, int n) {
  int i, j, k;

  for (i = 0; i < n; i++) {
    for (j = 0; j < (i + 1); j++) {
      double s = 0;
      for (k = 0; k < j; k++)
        s += L[hook(1, i * n + k)] * L[hook(1, j * n + k)];

      L[hook(1, i * n + j)] = (i == j) ? sqrt(A[hook(0, i * n + i)] - s) : (1.0 / L[hook(1, j * n + j)] * (A[hook(0, i * n + j)] - s));
    }
  }
}