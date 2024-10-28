//{"A":0,"B":1,"C":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mult_mat(global const float* A, global const float* B, global float* C) {
  int col = get_global_id(0);
  int row = get_global_id(1);

  float val;

  for (int i = 0; i < 100; i++) {
    val += A[hook(0, row * 100 + i)] * B[hook(1, i * 100 + col)];
  }
  C[hook(2, row * 100 + col)] = val;
}