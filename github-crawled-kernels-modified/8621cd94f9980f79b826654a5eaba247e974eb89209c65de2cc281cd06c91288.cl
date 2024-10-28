//{"A":0,"A_col_inc":4,"A_col_size":6,"A_col_start":2,"A_internal_cols":8,"A_internal_rows":7,"A_row_inc":3,"A_row_size":5,"A_row_start":1,"result":13,"result_inc":15,"result_size":16,"result_start":14,"v":9,"v_inc":11,"v_size":12,"v_start":10,"work":17}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void trans_vec_mul(global const float* A, unsigned int A_row_start, unsigned int A_col_start, unsigned int A_row_inc, unsigned int A_col_inc, unsigned int A_row_size, unsigned int A_col_size, unsigned int A_internal_rows, unsigned int A_internal_cols, global const float* v, unsigned int v_start, unsigned int v_inc, unsigned int v_size, global float* result, unsigned int result_start, unsigned int result_inc, unsigned int result_size, local float* work) {
  unsigned int row_gid = get_global_id(0) / get_local_size(0);
  unsigned int col_gid = get_global_id(0) % get_local_size(0);
  unsigned int lid = get_local_id(0);

  for (unsigned int row = row_gid; row < A_col_size; row += get_num_groups(0)) {
    float dot_prod = 0;
    for (unsigned int col = col_gid; col < A_row_size; col += get_local_size(0))
      dot_prod += A[hook(0, (row * A_col_inc + A_col_start) * A_internal_rows + col * A_row_inc + A_row_start)] * v[hook(9, v_start + v_inc * col)];
    work[hook(17, lid)] = dot_prod;

    for (unsigned int stride = get_local_size(0) / 2; stride > 0; stride >>= 1) {
      barrier(0x01);
      if (lid < stride)
        work[hook(17, lid)] += work[hook(17, lid + stride)];
    }

    if (lid == 0)
      result[hook(13, row * result_inc + result_start)] = work[hook(17, 0)];
  }
}