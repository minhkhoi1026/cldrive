//{"A":0,"A_col_inc":4,"A_col_size":6,"A_col_start":2,"A_internal_cols":8,"A_internal_rows":7,"A_row_inc":3,"A_row_size":5,"A_row_start":1,"result":13,"result_inc":15,"result_size":16,"result_start":14,"v":9,"v_inc":11,"v_size":12,"v_start":10,"work":17}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vec_mul(global const float* A, unsigned int A_row_start, unsigned int A_col_start, unsigned int A_row_inc, unsigned int A_col_inc, unsigned int A_row_size, unsigned int A_col_size, unsigned int A_internal_rows, unsigned int A_internal_cols, global const float* v, unsigned int v_start, unsigned int v_inc, unsigned int v_size, global float* result, unsigned int result_start, unsigned int result_inc, unsigned int result_size, local float* work) {
  for (unsigned int row = get_global_id(0); row < A_row_size; row += get_global_size(0)) {
    float dot_prod = 0;
    for (unsigned int col = 0; col < A_col_size; ++col)
      dot_prod += A[hook(0, (row * A_row_inc + A_row_start) + (col * A_col_inc + A_col_start) * A_internal_rows)] * v[hook(9, v_start + v_inc * col)];
    result[hook(13, row * result_inc + result_start)] = dot_prod;
  }
}