//{"W1":0,"W1_col_inc":4,"W1_col_size":6,"W1_col_start":2,"W1_internal_cols":8,"W1_internal_rows":7,"W1_row_inc":3,"W1_row_size":5,"W1_row_start":1,"W2":9,"W2_col_inc":13,"W2_col_size":15,"W2_col_start":11,"W2_internal_cols":17,"W2_internal_rows":16,"W2_row_inc":12,"W2_row_size":14,"W2_row_start":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void recombineWeightsWithAverage(global float* W1, unsigned int W1_row_start, unsigned int W1_col_start, unsigned int W1_row_inc, unsigned int W1_col_inc, unsigned int W1_row_size, unsigned int W1_col_size, unsigned int W1_internal_rows, unsigned int W1_internal_cols, global const float* W2, unsigned int W2_row_start, unsigned int W2_col_start, unsigned int W2_row_inc, unsigned int W2_col_inc, unsigned int W2_row_size, unsigned int W2_col_size, unsigned int W2_internal_rows, unsigned int W2_internal_cols) {
  unsigned int row_gid = get_global_id(0) / get_local_size(0);
  unsigned int col_gid = get_global_id(0) % get_local_size(0);
  for (unsigned int row = row_gid; row < W1_row_size && row < W2_row_size; row += get_num_groups(0)) {
    for (unsigned int col = col_gid; col < W1_col_size && col < W2_col_size; col += get_local_size(0)) {
      W1[hook(0, (row * W1_row_inc + W1_row_start) * W1_internal_cols + col * W1_col_inc + W1_col_start)] += W2[hook(9, (row * W2_row_inc + W2_row_start) * W2_internal_cols + col * W2_col_inc + W2_col_start)];
      W1[hook(0, (row * W1_row_inc + W1_row_start) * W1_internal_cols + col * W1_col_inc + W1_col_start)] /= 2;
    }
  }
}