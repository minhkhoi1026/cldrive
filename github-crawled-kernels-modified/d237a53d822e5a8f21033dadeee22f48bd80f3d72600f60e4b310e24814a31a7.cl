//{"A":0,"B":1,"n":3,"x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pmax(global int* A, global int* B, const int x, const unsigned int n) {
  const int globalRow = get_global_id(0);

  if (globalRow < n) {
    B[hook(1, globalRow)] = min(A[hook(0, globalRow)], x);
  }
}