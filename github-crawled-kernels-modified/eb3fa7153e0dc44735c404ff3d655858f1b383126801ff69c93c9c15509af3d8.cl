//{"A":0,"B":1,"C":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sigmod(float in) {
  return 1.0f / (1.0f + exp(-in));
}

__attribute__((reqd_work_group_size(1, 1, 1))) kernel void conv1(global float* A, global float* B, global float* C) {
  for (int m = 0; m < 6; ++m) {
    for (int p = 0; p < 784; ++p) {
      float sum = 0.0f;
      for (int n = 0; n < 25; n += 5) {
        for (int i = 0; i < 5; ++i) {
          sum += A[hook(0, m * 25 + n + i)] * B[hook(1, (n + i) * 784 + p)];
        }
      }
      C[hook(2, m * 784 + p)] = sum;
    }
  }
}