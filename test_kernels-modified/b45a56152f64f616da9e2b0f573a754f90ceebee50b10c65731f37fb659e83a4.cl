//{"matrix":0,"matrix_cols":2,"matrix_internal_cols":4,"matrix_internal_rows":3,"matrix_rows":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lu_factorize(global float* matrix, unsigned int matrix_rows, unsigned int matrix_cols, unsigned int matrix_internal_rows, unsigned int matrix_internal_cols) {
  float temp;
  for (unsigned int i = 1; i < matrix_rows; ++i) {
    for (unsigned int k = 0; k < i; ++k) {
      if (get_global_id(0) == 0)
        matrix[hook(0, i + k * matrix_internal_rows)] /= matrix[hook(0, k + k * matrix_internal_rows)];

      barrier(0x02);
      temp = matrix[hook(0, i + k * matrix_internal_rows)];

      for (unsigned int j = k + 1 + get_global_id(0); j < matrix_cols; j += get_global_size(0))
        matrix[hook(0, i + j * matrix_internal_rows)] -= temp * matrix[hook(0, k + j * matrix_internal_rows)];
    }
  }
}