//{"A":0,"X":1,"Y":4,"m":3,"n":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matVecMult(const global float* A, const global float* X, int n, int m, global float* Y) {
  const int i = get_global_id(0);
  if (i < m) {
    float val = 0;
    int j;

    for (j = 0; j < n; j++)
      val += A[hook(0, i * n + j)] * X[hook(1, j)];

    Y[hook(4, i)] = val;
  }
}