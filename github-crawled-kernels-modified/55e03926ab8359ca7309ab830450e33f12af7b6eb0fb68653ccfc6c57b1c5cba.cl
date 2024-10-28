//{"A":1,"B":2,"BWork":5,"C":3,"CWork":4,"N":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrixmul(const int N, global float* A, global float* B, global float* C, local float* CWork) {
  int i = get_global_id(0);
  int j, k;

  int iloc = get_local_id(0);
  int nloc = get_local_size(0);

 private
  float BWork[1024];

  for (k = 0; k < N; ++k) {
    BWork[hook(5, k)] = B[hook(2, i * N + k)];
  }

  for (j = 0; j < N; ++j) {
    for (k = iloc; k < N; k += nloc)
      CWork[hook(4, k)] = C[hook(3, k * N + j)];

    barrier(0x01);

    float temp = 0.0f;

    for (k = 0; k < N; ++k) {
      temp += BWork[hook(5, k)] * CWork[hook(4, k)];
    }

    A[hook(1, i * N + j)] = temp;
    barrier(0x01);
  }
}