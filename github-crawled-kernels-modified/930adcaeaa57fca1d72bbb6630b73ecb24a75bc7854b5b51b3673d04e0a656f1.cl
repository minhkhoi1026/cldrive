//{"A":0,"B":1,"C":2,"alpha":3,"beta":4,"n":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gemm(global double const* restrict A, global double const* restrict B, global double* restrict C, double alpha, double beta, unsigned int n) {
  const unsigned int j = get_global_id(0);
  const unsigned int i = get_global_id(1);

  double ABij = 0.0;
  for (unsigned int k = 0; k < n; k += 1) {
    ABij += A[hook(0, i * n + k)] * B[hook(1, k * n + j)];
  }
  C[hook(2, i * n + j)] = alpha * ABij + beta * C[hook(2, i * n + j)];
}