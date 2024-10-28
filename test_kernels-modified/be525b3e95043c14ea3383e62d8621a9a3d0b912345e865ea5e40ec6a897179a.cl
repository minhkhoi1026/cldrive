//{"A":0,"B_delta":2,"N":3,"X":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void validate(global float* A, global float* X, global float* B_delta, const unsigned int N) {
  int j = get_global_id(0);
  float value = 0;

  for (int k = 0; k < N; k++) {
    value = value + A[hook(0, k + j * (N + 1))] * X[hook(1, k)];
  }
  B_delta[hook(2, j)] = A[hook(0, N + j * (N + 1))] - value;
}