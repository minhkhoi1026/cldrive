//{"matrix":0,"matrix_cols":2,"matrix_internal_cols":4,"matrix_internal_rows":3,"matrix_rows":1,"result":6,"vector":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void trans_vec_mul(global const float* matrix, unsigned int matrix_rows, unsigned int matrix_cols, unsigned int matrix_internal_rows, unsigned int matrix_internal_cols, global const float* vector, global float* result) {
  for (unsigned int row = get_global_id(0); row < matrix_cols; row += get_global_size(0)) {
    float dot_prod2 = 0.0f;
    for (unsigned int col = 0; col < matrix_rows; ++col)
      dot_prod2 += matrix[hook(0, row + col * matrix_internal_cols)] * vector[hook(5, col)];
    result[hook(6, row)] = dot_prod2;
  }
}