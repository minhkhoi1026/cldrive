//{"A":0,"A_cols":2,"A_internal_cols":4,"A_internal_rows":3,"A_rows":1,"B":5,"B_cols":7,"B_internal_cols":9,"B_internal_rows":8,"B_rows":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lower_solve(global const float* A, unsigned int A_rows, unsigned int A_cols, unsigned int A_internal_rows, unsigned int A_internal_cols, global float* B, unsigned int B_rows, unsigned int B_cols, unsigned int B_internal_rows, unsigned int B_internal_cols) {
  float temp;
  for (int row = 0; row < A_rows; ++row) {
    barrier(0x02);
    if (get_local_id(0) == 0)
      B[hook(5, row + get_group_id(0) * B_internal_rows)] /= A[hook(0, row + row * A_internal_cols)];
    barrier(0x02);
    temp = B[hook(5, row + get_group_id(0) * B_internal_rows)];

    for (int elim = row + get_local_id(0) + 1; elim < A_rows; elim += get_local_size(0))
      B[hook(5, elim + get_group_id(0) * B_internal_rows)] -= temp * A[hook(0, elim + row * A_internal_rows)];
  }
}