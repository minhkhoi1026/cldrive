//{"A":1,"Awrk":5,"B":2,"Bwrk":4,"C":3,"N":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mmul(const int N, global float* A, global float* B, global float* C, local float* Bwrk) {
  int k, j;
  int i = get_global_id(0);
  int iloc = get_local_id(0);
  int nloc = get_local_size(0);
  float Awrk[1024];
  float tmp;
  if (i < N) {
    for (k = 0; k < N; k++)
      Awrk[hook(5, k)] = A[hook(1, i * N + k)];

    for (j = 0; j < N; j++) {
      barrier(0x01);
      for (k = iloc; k < N; k += nloc)
        Bwrk[hook(4, k)] = B[hook(2, k * N + j)];
      barrier(0x01);
      tmp = 0.0f;
      for (k = 0; k < N; k++)
        tmp += Awrk[hook(5, k)] * Bwrk[hook(4, k)];
      C[hook(3, i * N + j)] = tmp;
      barrier(0x01);
    }
  }
}