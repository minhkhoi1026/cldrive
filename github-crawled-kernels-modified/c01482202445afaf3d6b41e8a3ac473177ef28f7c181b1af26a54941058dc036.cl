//{"A":0,"K":3,"M":2,"X":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void second_step(global float* A, global float* X, int M, int K) {
  int i = get_global_id(0);
  float T = 0;

  T = A[hook(0, (M - 1) + M * K)] / A[hook(0, K + M * K)];
  if (i == K) {
    X[hook(1, K)] = T;
  } else {
    A[hook(0, (M - 1) + M * i)] = A[hook(0, (M - 1) + M * i)] - A[hook(0, K + M * i)] * T;
  }
}