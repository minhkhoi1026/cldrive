//{"A":0,"B":1,"R":3,"X":2,"n":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void r(global float* A, global float* B, global float* X, global float* R, unsigned int n) {
  unsigned int i = get_global_id(0);
  unsigned int j;
  if (i >= n)
    return;

  R[hook(3, i)] = B[hook(1, i)];
  for (j = 0; j < n; j++) {
    R[hook(3, i)] -= A[hook(0, j + i * n)] * X[hook(2, j)];
  }
}