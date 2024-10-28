//{"A":0,"Arow":4,"B":1,"C":2,"M":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_mul4(global float* A, global float* B, global float* C, int M) {
  int i = get_global_id(0);

  float Arow[1024];
  float tmp;
  for (int k = 0; k < M; ++k) {
    Arow[hook(4, k)] = A[hook(0, i * M + k)];
  }

  for (int j = 0; j < M; ++j) {
    tmp = 0.0f;
    for (int k = 0; k < M; ++k) {
      tmp += Arow[hook(4, k)] * B[hook(1, k * M + j)];
    }
    C[hook(2, i * M + j)] += tmp;
  }
}