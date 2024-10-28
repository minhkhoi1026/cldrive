//{"A":0,"col":2,"n":3,"v":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void column(global float* A, global float* v, unsigned int col, unsigned int n) {
  unsigned int i = get_global_id(0);
  if (i >= n)
    return;
  v[hook(1, i)] = A[hook(0, i + col * n)];
}