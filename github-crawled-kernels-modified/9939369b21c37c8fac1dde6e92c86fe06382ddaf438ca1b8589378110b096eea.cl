//{"A":1,"B":2,"C":0,"side":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void square_matrix_multiply(global int* C, global const int* A, global const int* B, const int side) {
  int row = get_global_id(0);
  int col = get_global_id(1);

  C[hook(0, row * side + col)] = 0;
  for (int i = 0; i < side; ++i)
    C[hook(0, row * side + col)] += A[hook(1, row * side + i)] * B[hook(2, i * side + col)];
}