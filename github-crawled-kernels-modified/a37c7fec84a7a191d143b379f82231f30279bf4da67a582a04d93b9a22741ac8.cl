//{"A":0,"X":1,"Y":2,"n":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dot_matT_vec(global float* A, global float* X, global float* Y, unsigned int n) {
  unsigned int i = get_global_id(0);
  unsigned int j;
  if (i >= n)
    return;

  Y[hook(2, i)] = 0.f;
  for (j = 0; j < n; j++) {
    Y[hook(2, i)] += A[hook(0, i + j * n)] * X[hook(1, j)];
  }
}