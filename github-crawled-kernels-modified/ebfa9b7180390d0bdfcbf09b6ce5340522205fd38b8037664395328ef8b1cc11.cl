//{"A":0,"B":1,"C":2,"d_nA":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matmult(global double* A, global double* B, global double* C, global size_t* d_nA) {
  int row = get_global_id(0);
  int col = get_global_id(1);
    int n = *d_nA;

  double Cvalue = 0;

  if ((row * col) < (n * n)) {
    int index_a, index_b;

    for (int k = 0; k < n; k++) {
      index_a = row + k * n;
      index_b = col * n + k;
      Cvalue += A[hook(0, index_a)] * B[hook(1, index_b)];
    }

    C[hook(2, row + n * col)] = Cvalue;
  }
}