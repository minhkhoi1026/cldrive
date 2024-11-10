//{"A":0,"A_cols":2,"A_internal_cols":4,"A_internal_rows":3,"A_rows":1,"B":5,"B_cols":7,"B_internal_cols":9,"B_internal_rows":8,"B_rows":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void trans_unit_upper_trans_solve(global const float* A, unsigned int A_rows, unsigned int A_cols, unsigned int A_internal_rows, unsigned int A_internal_cols, global float* B, unsigned int B_rows, unsigned int B_cols, unsigned int B_internal_rows, unsigned int B_internal_cols) {
  float temp;
  for (int row = A_rows - 1; row > -1; --row) {
    barrier(0x02);
    temp = B[hook(5, row * B_internal_rows + get_group_id(0))];

    for (int elim = get_local_id(0); elim < row; elim += get_local_size(0))
      B[hook(5, elim * B_internal_rows + get_group_id(0))] -= temp * A[hook(0, elim + row * A_internal_cols)];
  }
}