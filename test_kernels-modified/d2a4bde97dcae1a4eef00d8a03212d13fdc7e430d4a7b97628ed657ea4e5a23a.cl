//{"A":0,"B":1,"X":3,"X0":2,"n":5,"w":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void jacobi(global float* A, global float* B, global float* X0, global float* X, float w, unsigned int n) {
  unsigned int i = get_global_id(0);
  unsigned int j;
  if (i >= n)
    return;

  X[hook(3, i)] = B[hook(1, i)];
  for (j = 0; j < n; j++) {
    if (i == j) {
      continue;
    }
    X[hook(3, i)] += A[hook(0, j + i * n)] * X0[hook(2, j)];
  }
  X[hook(3, i)] *= w / A[hook(0, i + i * n)];
  X[hook(3, i)] += (1.f - w) * X0[hook(2, i)];
}