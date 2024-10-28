//{"buff_A":0,"buff_B":1,"cols":4,"rows":3,"temp":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void row_col(global float* restrict buff_A, global float* restrict buff_B, global float* restrict temp, int rows, int cols) {
  int row, col;

  for (row = 0; row < rows; row++) {
    for (col = 0; col < cols; col++) {
      if (col < cols) {
        buff_A[hook(0, 2 * cols + col)] = buff_A[hook(0, 1 * cols + col)];
        buff_A[hook(0, 1 * cols + col)] = buff_A[hook(0, 0 * cols + col)];
        buff_B[hook(1, 1 * cols + col)] = buff_B[hook(1, 0 * cols + col)];
        *temp = buff_A[hook(0, 0 * cols + col)];
      }
    }
  }
}