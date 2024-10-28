//{"A":0,"Arow":4,"B":1,"Brow":5,"C":2,"M":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_mul5(global float* A, global float* B, global float* C, int M) {
  int i = get_global_id(0);
  int iloc = get_local_id(0);
  int nloc = get_local_size(0);

  float Arow[1024];
  local float Brow[1024];
  float tmp;
  for (int k = 0; k < M; ++k) {
    Arow[hook(4, k)] = A[hook(0, i * M + k)];
  }

  for (int j = 0; j < M; ++j) {
    for (int k = iloc; k < M; k += nloc) {
      Brow[hook(5, k)] = B[hook(1, k * M + j)];
    }
    barrier(0x01);

    tmp = 0.0f;
    for (int k = 0; k < M; ++k) {
      tmp += Arow[hook(4, k)] * Brow[hook(5, k)];
    }
    C[hook(2, i * M + j)] += tmp;
  }
}