//{"block_elems_num":11,"block_ind":7,"column_indices":1,"com_A_I_J":9,"elements":2,"g_is_update":10,"i_ind":5,"j_ind":6,"matrix_dimensions":8,"row_indices":0,"set_I":3,"set_J":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float get_element(global const unsigned int* row_indices, global const unsigned int* column_indices, global const float* elements, unsigned int row, unsigned int col) {
  unsigned int row_end = row_indices[hook(0, row + 1)];
  for (unsigned int i = row_indices[hook(0, row)]; i < row_end; ++i) {
    if (column_indices[hook(1, i)] == col)
      return elements[hook(2, i)];
    if (column_indices[hook(1, i)] > col)
      return 0.0;
  }
  return 0.0;
}

void block_assembly(global const unsigned int* row_indices, global const unsigned int* column_indices, global const float* elements, global const unsigned int* matrix_dimensions, global const unsigned int* set_I, global const unsigned int* set_J, unsigned int matrix_ind, global float* com_A_I_J) {
  unsigned int row_n = matrix_dimensions[hook(8, 2 * matrix_ind)];
  unsigned int col_n = matrix_dimensions[hook(8, 2 * matrix_ind + 1)];

  for (unsigned int i = 0; i < col_n; ++i) {
    for (unsigned int j = 0; j < row_n; j++) {
      com_A_I_J[hook(9, i * row_n + j)] = get_element(row_indices, column_indices, elements, set_I[hook(3, j)], set_J[hook(4, i)]);
    }
  }
}

kernel void assemble_blocks(global const unsigned int* row_indices, global const unsigned int* column_indices, global const float* elements, global const unsigned int* set_I, global const unsigned int* set_J, global const unsigned int* i_ind, global const unsigned int* j_ind, global const unsigned int* block_ind, global const unsigned int* matrix_dimensions, global float* com_A_I_J, global unsigned int* g_is_update, unsigned int block_elems_num) {
  for (unsigned int i = get_global_id(0); i < block_elems_num; i += get_global_size(0)) {
    if ((matrix_dimensions[hook(8, 2 * i)] > 0) && (matrix_dimensions[hook(8, 2 * i + 1)] > 0) && g_is_update[hook(10, i)] > 0) {
      block_assembly(row_indices, column_indices, elements, matrix_dimensions, set_I + i_ind[hook(5, i)], set_J + j_ind[hook(6, i)], i, com_A_I_J + block_ind[hook(7, i)]);
    }
  }
}