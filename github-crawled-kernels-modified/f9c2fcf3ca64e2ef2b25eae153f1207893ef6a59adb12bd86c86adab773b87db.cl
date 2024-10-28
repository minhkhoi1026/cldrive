//{"col":3,"max_row":2,"num_cols":1,"num_rows":0,"val":4,"x":5,"y":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void s_kernel_ell_spmv(const int num_rows, const int num_cols, const int max_row, global const int* col, global const float* val, global const float* x, global float* y) {
  int row = get_global_id(0);

  if (row >= num_rows)
    return;

  float sum = (float)0;
  for (int i = 0; i < max_row; i++) {
    const int ind = i * num_rows + row;
    const int column = col[hook(3, ind)];

    if (column < 0)
      break;
    sum += val[hook(4, ind)] * x[hook(5, column)];
  }
  y[hook(6, row)] = sum;
}