//{"W1":0,"W1_col_inc":4,"W1_col_size":6,"W1_col_start":2,"W1_internal_cols":8,"W1_internal_rows":7,"W1_row_inc":3,"W1_row_size":5,"W1_row_start":1,"mutationStrength":9,"mutationStrengthIndexOffset":13,"mutationStrength_inc":11,"mutationStrength_size":12,"mutationStrength_start":10,"randNumbers":14,"randNumbersOffset":15}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mutateWeights(global float* W1, unsigned int W1_row_start, unsigned int W1_col_start, unsigned int W1_row_inc, unsigned int W1_col_inc, unsigned int W1_row_size, unsigned int W1_col_size, unsigned int W1_internal_rows, unsigned int W1_internal_cols, global float* mutationStrength, unsigned int mutationStrength_start, unsigned int mutationStrength_inc, unsigned int mutationStrength_size, unsigned int mutationStrengthIndexOffset, global float* randNumbers, unsigned int randNumbersOffset) {
  unsigned int row_gid = get_global_id(0) / get_local_size(0);
  unsigned int col_gid = get_global_id(0) % get_local_size(0);
  for (unsigned int row = row_gid; row < W1_row_size; row += get_num_groups(0)) {
    for (unsigned int col = col_gid; col < W1_col_size; col += get_local_size(0)) {
      W1[hook(0, (row * W1_row_inc + W1_row_start) * W1_internal_cols + col * W1_col_inc + W1_col_start)] += mutationStrength[hook(9, (row * W1_col_size + col + mutationStrengthIndexOffset) * mutationStrength_inc + mutationStrength_start)] * randNumbers[hook(14, randNumbersOffset + row * W1_col_size + col)];
    }
  }
}