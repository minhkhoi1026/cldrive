//{"A":3,"B":4,"C":5,"K":2,"M":0,"N":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mult_naive(const int M, const int N, const int K, global const float* A, global const float* B, global float* C) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  float acc = 0.0f;
  for (int k = 0; k < K; k++) {
    int idx_a = k * M + i;
    int idx_b = j * K + k;
    acc += A[hook(3, idx_a)] * B[hook(4, idx_b)];
  }

  C[hook(5, j * N + i)] = acc;
}