//{"A":0,"B":1,"n":3,"x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pmax(global float* A, global float* B, const float x, const unsigned int n) {
  const int globalRow = get_global_id(0);

  if (globalRow < n) {
    B[hook(1, globalRow)] = max(A[hook(0, globalRow)], x);
  }
}