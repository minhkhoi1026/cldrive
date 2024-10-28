//{"data":3,"float_n":2,"m":0,"mean":5,"n":1,"symmat":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_covariance(int m, int n, float float_n, global float* restrict data, global float* restrict symmat, global float* restrict mean) {
  int i, j, j1, j2;

  for (j = 0; j < m; j++) {
    mean[hook(5, j)] = 0.0;
    for (i = 0; i < n; i++)
      mean[hook(5, j)] += data[hook(3, i * n + j)];
    mean[hook(5, j)] /= float_n;
  }

  for (i = 0; i < n; i++)
    for (j = 0; j < m; j++)
      data[hook(3, i * n + j)] -= mean[hook(5, j)];

  for (j1 = 0; j1 < m; j1++)
    for (j2 = j1; j2 < m; j2++) {
      symmat[hook(4, j1 * m + j2)] = 0.0;

      for (i = 0; i < n; i++)
        symmat[hook(4, j1 * m + j2)] += data[hook(3, i * n + j1)] * data[hook(3, i * n + j2)];

      symmat[hook(4, j2 * m + j1)] = symmat[hook(4, j1 * m + j2)];
    }
}