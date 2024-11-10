//{"A":1,"B":2,"C":3,"N":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mmul(const int N, global float* A, global float* B, global float* C) {
  int k, j;
  int i = get_global_id(0);
  float tmp;
  if (i < N) {
    for (j = 0; j < N; j++) {
      tmp = 0.0;
      for (k = 0; k < N; k++)
        tmp += A[hook(1, i * N + k)] * B[hook(2, k * N + j)];
      C[hook(3, i * N + j)] = tmp;
    }
  }
}