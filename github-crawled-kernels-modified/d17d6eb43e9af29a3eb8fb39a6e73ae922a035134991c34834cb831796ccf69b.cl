//{"A":3,"B":4,"C":5,"Mdim":0,"Ndim":1,"Pdim":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mmul(const int Mdim, const int Ndim, const int Pdim, global float* A, global float* B, global float* C) {
  int k;
  int i = get_global_id(0);
  int j = get_global_id(1);
  float tmp;
  if ((i < Ndim) && (j < Mdim)) {
    tmp = 0.0f;
    for (k = 0; k < Pdim; k++)
      tmp += A[hook(3, i * Ndim + k)] * B[hook(4, k * Pdim + j)];
    C[hook(5, i * Ndim + j)] = tmp;
  }
}