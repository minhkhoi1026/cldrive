//{"A":0,"B":2,"M":1,"k":4,"n":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matmat_single(global const double* A, global const double* M, global double* B, int n, int k) {
  int gid = get_global_id(0);
  const int stride = get_global_size(0);

  double sum;
  while (gid < n) {
    for (int j = 0; j < k; ++j) {
      sum = 0.0;
      for (int i = 0; i < n; ++i)
        sum += A[hook(0, gid * n + i)] * M[hook(1, k * i + j)];

      B[hook(2, gid * k + j)] = sum;
    }

    gid += stride;
  }
}