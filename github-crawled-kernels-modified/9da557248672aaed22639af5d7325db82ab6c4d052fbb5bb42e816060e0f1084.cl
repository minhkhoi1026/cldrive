//{"matrix":0,"matrix_cols":2,"matrix_internal_cols":4,"matrix_internal_rows":3,"matrix_rows":1,"vector":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void trans_upper_triangular_substitute_inplace(global const float* matrix, unsigned int matrix_rows, unsigned int matrix_cols, unsigned int matrix_internal_rows, unsigned int matrix_internal_cols, global float* vector) {
  float temp;
  for (int row = matrix_rows - 1; row > -1; --row) {
    barrier(0x02);
    if (get_global_id(0) == 0)
      vector[hook(5, row)] /= matrix[hook(0, row + row * matrix_internal_rows)];

    barrier(0x02);

    temp = vector[hook(5, row)];

    for (int elim = get_global_id(0); elim < row; elim += get_global_size(0))
      vector[hook(5, elim)] -= temp * matrix[hook(0, row + elim * matrix_internal_rows)];
  }
}