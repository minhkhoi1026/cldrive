//{"A":3,"Awrk":6,"B":4,"C":5,"Mdim":0,"Ndim":1,"Pdim":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mmul(const int Mdim, const int Ndim, const int Pdim, global float* A, global float* B, global float* C) {
  int k, j;
  int i = get_global_id(0);
  float Awrk[1024];
  float tmp;
  if (i < Ndim) {
    for (k = 0; k < Pdim; k++)
      Awrk[hook(6, k)] = A[hook(3, i * Ndim + k)];
    for (j = 0; j < Mdim; j++) {
      tmp = 0.0f;
      for (k = 0; k < Pdim; k++)
        tmp += Awrk[hook(6, k)] * B[hook(4, k * Pdim + j)];
      C[hook(5, i * Ndim + j)] = tmp;
    }
  }
}