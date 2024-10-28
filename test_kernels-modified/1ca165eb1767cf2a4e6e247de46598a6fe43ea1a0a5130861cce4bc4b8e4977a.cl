//{"matrix":0,"matrix_cols":2,"matrix_internal_cols":4,"matrix_internal_rows":3,"matrix_rows":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lu_factorize(global float* matrix, unsigned int matrix_rows, unsigned int matrix_cols, unsigned int matrix_internal_rows, unsigned int matrix_internal_cols) {
  float temp;
  unsigned rowi;
  unsigned rowk;
  for (unsigned int i = 1; i < matrix_rows; ++i) {
    rowi = i * matrix_internal_cols;
    for (unsigned int k = 0; k < i; ++k) {
      rowk = k * matrix_internal_cols;
      if (get_global_id(0) == 0)
        matrix[hook(0, rowi + k)] /= matrix[hook(0, rowk + k)];

      barrier(0x02);
      temp = matrix[hook(0, rowi + k)];

      for (unsigned int j = k + 1 + get_global_id(0); j < matrix_rows; j += get_global_size(0))
        matrix[hook(0, rowi + j)] -= temp * matrix[hook(0, rowk + j)];
    }
  }
}