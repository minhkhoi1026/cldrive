//{"data":3,"float_n":2,"m":0,"mean":5,"n":1,"stddev":6,"symmat":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_correlation(int m, int n, float float_n, global float* restrict data, global float* restrict symmat, global float* restrict mean, global float* restrict stddev) {
  int i, j, j1, j2;

  float eps = 0.1f;

  for (j = 0; j < m; j++) {
    mean[hook(5, j)] = 0.0;
    for (i = 0; i < n; i++)
      mean[hook(5, j)] += data[hook(3, i * n + j)];
    mean[hook(5, j)] /= float_n;
  }

  for (j = 0; j < m; j++) {
    stddev[hook(6, j)] = 0.0;
    for (i = 0; i < n; i++)
      stddev[hook(6, j)] += (data[hook(3, i * n + j)] - mean[hook(5, j)]) * (data[hook(3, i * n + j)] - mean[hook(5, j)]);
    stddev[hook(6, j)] /= float_n;
    stddev[hook(6, j)] = sqrt(stddev[hook(6, j)]);

    stddev[hook(6, j)] = stddev[hook(6, j)] <= eps ? 1.0 : stddev[hook(6, j)];
  }

  for (i = 0; i < n; i++) {
    for (j = 0; j < m; j++) {
      data[hook(3, i * n + j)] -= mean[hook(5, j)];
      data[hook(3, i * n + j)] /= sqrt(float_n) * stddev[hook(6, j)];
    }
  }

  for (j1 = 0; j1 < m - 1; j1++) {
    symmat[hook(4, j1 * m + j1)] = 1.0;
    for (j2 = j1 + 1; j2 < m; j2++) {
      symmat[hook(4, j1 * m + j2)] = 0.0;
      for (i = 0; i < n; i++)
        symmat[hook(4, j1 * m + j2)] += (data[hook(3, i * n + j1)] * data[hook(3, i * n + j2)]);

      symmat[hook(4, j2 * m + j1)] = symmat[hook(4, j1 * m + j2)];
    }
  }

  symmat[hook(4, (m - 1) * m + m - 1)] = 1.0;
}