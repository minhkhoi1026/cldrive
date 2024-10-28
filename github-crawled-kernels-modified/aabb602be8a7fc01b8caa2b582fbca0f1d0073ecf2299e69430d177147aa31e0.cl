//{"A":0,"B":1,"C":2,"alpha":6,"beta":7,"k":5,"m":3,"n":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dgemm(global double* A, global double* B, global double* C, global int* m, global int* n, global int* k, global double* alpha, global double* beta) {
  int ROW = get_global_id(1);
  int COL = get_global_id(0);

  if (ROW < (n[hook(4, 0)]) && COL < (m[hook(3, 0)])) {
    double sum = 0.0;
    for (int i = 0; i < k[hook(5, 0)]; i++)
      sum += (alpha[hook(6, 0)]) * A[hook(0, ROW * (k[0hook(5, 0)) + i)] * B[hook(1, i * (n[0hook(4, 0)) + COL)];
    C[hook(2, ROW * (n[0hook(4, 0)) + COL)] = sum + (beta[hook(7, 0)]) * C[hook(2, ROW * (n[0hook(4, 0)) + COL)];
  }
}