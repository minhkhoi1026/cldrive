//{"A":0,"alpha":4,"n":5,"u":3,"u0":1,"v0":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void u(global float* A, global float* u0, global float* v0, global float* u, float alpha, unsigned int n) {
  unsigned int i = get_global_id(0);
  unsigned int j;
  if (i >= n)
    return;

  u[hook(3, i)] = -alpha * u0[hook(1, i)];
  for (j = 0; j < n; j++) {
    u[hook(3, i)] += A[hook(0, j + i * n)] * v0[hook(2, j)];
  }
}