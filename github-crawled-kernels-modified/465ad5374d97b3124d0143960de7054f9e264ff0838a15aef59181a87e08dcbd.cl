//{"float2":6,"matrix":0,"matrix_cols":2,"matrix_internal_cols":4,"matrix_internal_rows":3,"matrix_rows":1,"vector1":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rank1_update(global float* matrix, unsigned int matrix_rows, unsigned int matrix_cols, unsigned int matrix_internal_rows, unsigned int matrix_internal_cols, global const float* vector1, global const float* float2) {
  float tmp;
  unsigned int offset;

  for (unsigned int row = get_global_id(0); row < matrix_rows; row += get_global_size(0)) {
    tmp = vector1[hook(5, row)];
    offset = row * matrix_internal_cols;
    for (unsigned int col = 0; col < matrix_cols; ++col)
      matrix[hook(0, offset + col)] += tmp * float2[hook(6, col)];
  }
}