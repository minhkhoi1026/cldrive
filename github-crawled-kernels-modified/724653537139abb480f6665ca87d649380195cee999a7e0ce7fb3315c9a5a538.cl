//{"A":0,"b":2,"n":3,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matvec_single(global const double* A, global const double* x, global double* b, int n) {
  int gid = get_global_id(0);
  const int stride = get_global_size(0);

  double sum;
  while (gid < n) {
    sum = 0.0;
    for (int i = 0; i < n; ++i)
      sum += A[hook(0, gid * n + i)] * x[hook(1, i)];
    b[hook(2, gid)] = sum;

    gid += stride;
  }
}