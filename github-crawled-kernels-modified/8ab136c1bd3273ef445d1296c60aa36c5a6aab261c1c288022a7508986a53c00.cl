//{"A":0,"B":1,"C":2,"M":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_mul1(global float* A, global float* B, global float* C, int M) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  for (int k = 0; k < M; ++k) {
    C[hook(2, i * M + j)] += A[hook(0, i * M + k)] * B[hook(1, k * M + j)];
  }
}