//{"A":0,"B":1,"C":2,"n":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matmul(global float* restrict A, global float* restrict B, global float* restrict C, unsigned int n) {
  for (size_t i = 0; i < n; i++)
    for (size_t j = 0; j < n; j++) {
      float dot = 0;
      for (size_t k = 0; k < n; k++)
        dot += A[hook(0, i * n + k)] * B[hook(1, k * n + j)];
      C[hook(2, i * n + j)] = dot;
    }
}