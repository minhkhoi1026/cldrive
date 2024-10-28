//{"A":0,"L":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cholesky_decomp(global float* restrict A, global float* restrict L) {
  int i, j, k;

  for (i = 0; i < 20; i++) {
    for (j = 0; j < (i + 1); j++) {
      double s = 0;
      for (k = 0; k < j; k++)
        s += L[hook(1, i * 20 + k)] * L[hook(1, j * 20 + k)];

      L[hook(1, i * 20 + j)] = (i == j) ? sqrt(A[hook(0, i * 20 + i)] - s) : (1.0 / L[hook(1, j * 20 + j)] * (A[hook(0, i * 20 + j)] - s));
    }
  }
}