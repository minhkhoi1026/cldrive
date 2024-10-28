//{"A":0,"C":1,"K":2,"M":4,"N":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void first_step(global float* A, global float* C, const unsigned int K, const unsigned int N, const unsigned int M) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  float T = 0;

  if (j > K) {
    T = A[hook(0, K + M * j)] / A[hook(0, K + M * K)];

    C[hook(1, i + M * j)] = A[hook(0, i + M * j)] - A[hook(0, i + M * K)] * T;
  } else {
    C[hook(1, i + M * j)] = A[hook(0, i + M * j)];
  }
}