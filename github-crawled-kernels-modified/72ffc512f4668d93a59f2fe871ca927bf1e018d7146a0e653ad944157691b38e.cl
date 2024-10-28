//{"A":0,"B":1,"C":2,"M":6,"N":5,"alpha":3,"beta":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((intel_reqd_sub_group_size(16))) kernel void test_gemm(const global float* A, const global float* B, global float* C, const float alpha, const float beta, const unsigned int N, const unsigned int M) {
  size_t glob_row = get_global_id(0);
  size_t glob_col = get_global_id(1);

  float acc = 0;
  for (size_t n = 0; n < N; ++n)
    acc += A[hook(0, n * M + glob_row)] * B[hook(1, glob_col * N + n)];

  C[hook(2, glob_col * M + glob_row)] = alpha * acc + beta * C[hook(2, glob_col * M + glob_row)];
}