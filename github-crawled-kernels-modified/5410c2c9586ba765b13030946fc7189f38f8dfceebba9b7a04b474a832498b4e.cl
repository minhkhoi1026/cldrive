//{"W":8,"W_col_inc":12,"W_col_size":14,"W_col_start":10,"W_internal_cols":16,"W_internal_rows":15,"W_row_inc":11,"W_row_size":13,"W_row_start":9,"actVec":0,"incAct":2,"incNetInput":6,"netInputVec":4,"sizeAct":3,"sizeNetInput":7,"startAct":1,"startNetInput":5,"work":17}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void execute2(global const float* actVec, unsigned int startAct, unsigned int incAct, unsigned int sizeAct, global float* netInputVec, unsigned int startNetInput, unsigned int incNetInput, unsigned int sizeNetInput, global const float* W, unsigned int W_row_start, unsigned int W_col_start, unsigned int W_row_inc, unsigned int W_col_inc, unsigned int W_row_size, unsigned int W_col_size, unsigned int W_internal_rows, unsigned int W_internal_cols, local float* work) {
  float sum = (float)0;
  for (int col = get_global_id(1); col < W_col_size; col += get_global_size(1)) {
    sum += W[hook(8, (get_global_id(0) * W_row_inc + W_row_start) * W_internal_cols + col * W_col_inc + W_col_start)] * actVec[hook(0, startAct + incAct * col)];
  }

  int rows = get_local_size(0);
  int cols = get_local_size(1);
  int ii = get_local_id(0);
  int jj = get_local_id(1);
  work[hook(17, ii + rows * jj)] = sum;
  barrier(0x01);

  while (cols > 1) {
    cols >>= 1;
    if (jj < cols)
      work[hook(17, ii + rows * jj)] += work[hook(17, ii + rows * (jj + cols))];
    barrier(0x01);
  }

  if (jj == 0)
    netInputVec[hook(4, get_global_id(0))] = work[hook(17, ii)];
}