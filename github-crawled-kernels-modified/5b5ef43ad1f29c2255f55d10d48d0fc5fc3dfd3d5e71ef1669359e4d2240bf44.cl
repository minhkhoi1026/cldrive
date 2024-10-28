//{"A":1,"Awrk":4,"B":2,"C":3,"N":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mmul(const int N, global float* A, global float* B, global float* C) {
  int k, j;
  int i = get_global_id(0);
  float Awrk[1024];
  float tmp;
  if (i < N) {
    for (k = 0; k < N; k++)
      Awrk[hook(4, k)] = A[hook(1, i * N + k)];

    for (j = 0; j < N; j++) {
      tmp = 0.0f;
      for (k = 0; k < N; k++)
        tmp += Awrk[hook(4, k)] * B[hook(2, k * N + j)];
      C[hook(3, i * N + j)] = tmp;
    }
  }
}