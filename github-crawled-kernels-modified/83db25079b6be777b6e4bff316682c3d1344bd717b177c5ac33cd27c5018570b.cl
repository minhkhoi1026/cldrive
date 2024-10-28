//{"A":3,"B":4,"C":5,"D":6,"K":2,"M":0,"N":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void GEMM1(const int M, const int N, const int K, const global float* A, const global float* B, global float* C, const global float* D) {
  const int m = get_global_id(0);
  const int n = get_global_id(1);

  float acc = 0.0f;
  for (int k = 0; k < K; k++) {
    acc += A[hook(3, m * K + k)] * B[hook(4, k * N + n)];
  }

  acc += D[hook(6, m)];

  C[hook(5, m * N + n)] = acc;
}