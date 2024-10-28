//{"W":8,"W_col_inc":12,"W_col_size":14,"W_col_start":10,"W_internal_cols":16,"W_internal_rows":15,"W_row_inc":11,"W_row_size":13,"W_row_start":9,"actVec":0,"incAct":2,"incNetInput":6,"netInputVec":4,"sizeAct":3,"sizeNetInput":7,"startAct":1,"startNetInput":5,"work":17}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void execute(global const float* actVec, unsigned int startAct, unsigned int incAct, unsigned int sizeAct, global float* netInputVec, unsigned int startNetInput, unsigned int incNetInput, unsigned int sizeNetInput, global const float* W, unsigned int W_row_start, unsigned int W_col_start, unsigned int W_row_inc, unsigned int W_col_inc, unsigned int W_row_size, unsigned int W_col_size, unsigned int W_internal_rows, unsigned int W_internal_cols, local float* work) {
  unsigned int row_gid = get_global_id(0) / get_local_size(0);
  unsigned int col_gid = get_global_id(0) % get_local_size(0);
  unsigned int lid = get_local_id(0);
  for (unsigned int row = row_gid; row < W_row_size; row += get_num_groups(0)) {
    float dot_prod = 0;
    for (unsigned int col = col_gid; col < W_col_size; col += get_local_size(0))
      dot_prod += W[hook(8, (row * W_row_inc + W_row_start) * W_internal_cols + col * W_col_inc + W_col_start)] * (col < sizeAct ? actVec[hook(0, startAct + incAct * col)] : 1);
    work[hook(17, lid)] = dot_prod;
    for (unsigned int stride = get_local_size(0) / 2; stride > 0; stride >>= 1) {
      barrier(0x01);
      if (lid < stride)
        work[hook(17, lid)] += work[hook(17, lid + stride)];
    }
    if (lid == 0)
      netInputVec[hook(4, row * incNetInput + startNetInput)] = work[hook(17, 0)];
  }
}