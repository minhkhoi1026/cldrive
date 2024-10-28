//{"A":3,"Awrk":7,"B":4,"Bwrk":6,"C":5,"Mdim":0,"Ndim":1,"Pdim":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mmul(const int Mdim, const int Ndim, const int Pdim, global float* A, global float* B, global float* C, local float* Bwrk) {
  int k, j;
  int i = get_global_id(0);
  int iloc = get_local_id(0);
  int nloc = get_local_size(0);
  float Awrk[1024];
  float tmp;
  if (i < Ndim) {
    for (k = 0; k < Pdim; k++)
      Awrk[hook(7, k)] = A[hook(3, i * Ndim + k)];
    for (j = 0; j < Mdim; j++) {
      for (k = iloc; k < Pdim; k += nloc)
        Bwrk[hook(6, k)] = B[hook(4, k * Pdim + j)];
      barrier(0x01);
      tmp = 0.0f;
      for (k = 0; k < Pdim; k++)
        tmp += Awrk[hook(7, k)] * Bwrk[hook(6, k)];
      C[hook(5, i * Ndim + j)] = tmp;
      barrier(0x01);
    }
  }
}