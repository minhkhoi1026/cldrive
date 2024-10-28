//{"A":0,"n":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void jacobi_2d(global float* restrict A, int n) {
  int i, j, t;

  for (t = 0; t < n; t++) {
    for (i = 1; i < n - 1; i++) {
      for (j = 1; j < n - 1; j++) {
        A[hook(0, i * n + j)] = 0.2 * (A[hook(0, i * n + j)] + A[hook(0, i * n + j - 1)] + A[hook(0, i * n + 1 + j)] + A[hook(0, (1 + i) * n + j)] + A[hook(0, (i - 1) * n + j)]);
      }
    }
  }

  return;
}