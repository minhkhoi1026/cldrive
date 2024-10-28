//{"A":0,"B":2,"M":1,"n":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void tensor_AII_single(global const double* A, global const double* M, global double* B, int n) {
  int gid = get_global_id(0);
  const int stride = get_global_size(0);

  double sum;
  while (gid < n) {
    for (int k = 0; k < n; ++k) {
      for (int j = 0; j < n; ++j) {
        sum = 0.0;
        for (int i = 0; i < n; ++i)
          sum += A[hook(0, n * gid + i)] * M[hook(1, i * n * n + n * k + j)];

        B[hook(2, gid * n * n + n * k + j)] = sum;
      }
    }

    gid += stride;
  }
}