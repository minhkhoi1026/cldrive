//{"A":0,"B":1,"C":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_sub(global const int* A, global const int* B, global int* C) {
  int i = get_global_id(0);
  int j = get_global_id(1);
  int cols = get_global_size(1);
  int idx = i * cols + j;
  C[hook(2, idx)] = A[hook(0, idx)] - B[hook(1, idx)];
}