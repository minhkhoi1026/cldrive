//{"A":2,"B":3,"C":1,"N":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void k_gen_cl_gemm_v0_(const int N, global float* C, global float* A, global float* B) {
  const int i = get_global_id(0);
  const int j = get_global_id(1);
  const int n = get_global_size(0);

  float tmp = 0.0f;

  for (int k = 0; k < n; k++)
    tmp += A[hook(2, k * n + j)] * B[hook(3, i * n + k)];

  C[hook(1, i * n + j)] = tmp;
}