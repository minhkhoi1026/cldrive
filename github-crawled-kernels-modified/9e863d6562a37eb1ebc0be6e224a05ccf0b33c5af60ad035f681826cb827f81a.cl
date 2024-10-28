//{"A":0,"beta":4,"n":5,"u":1,"v":3,"v0":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void v(global float* A, global float* u, global float* v0, global float* v, float beta, unsigned int n) {
  unsigned int i = get_global_id(0);
  unsigned int j;
  if (i >= n)
    return;

  v[hook(3, i)] = -beta * v0[hook(2, i)];
  for (j = 0; j < n; j++) {
    v[hook(3, i)] += A[hook(0, i + j * n)] * u[hook(1, j)];
  }
}