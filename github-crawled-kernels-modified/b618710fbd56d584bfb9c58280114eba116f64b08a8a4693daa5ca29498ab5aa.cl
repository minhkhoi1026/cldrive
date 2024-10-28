//{"A":0,"c":1,"col":2,"n":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prod_c_column(global float* A, float c, unsigned int col, unsigned int n) {
  unsigned int i = get_global_id(0);
  if (i >= n)
    return;
  A[hook(0, i + col * n)] *= c;
}