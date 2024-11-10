//{"float2":7,"matrix":0,"matrix_cols":2,"matrix_internal_cols":4,"matrix_internal_rows":3,"matrix_rows":1,"val":5,"vector1":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scaled_rank1_update(global float* matrix, unsigned int matrix_rows, unsigned int matrix_cols, unsigned int matrix_internal_rows, unsigned int matrix_internal_cols, float val, global const float* vector1, global const float* float2) {
  float tmp;

  for (unsigned int row = get_global_id(0); row < matrix_rows; row += get_global_size(0)) {
    tmp = val * vector1[hook(6, row)];
    for (unsigned int col = 0; col < matrix_cols; ++col)
      matrix[hook(0, row + col * matrix_internal_rows)] += tmp * float2[hook(7, col)];
  }
}