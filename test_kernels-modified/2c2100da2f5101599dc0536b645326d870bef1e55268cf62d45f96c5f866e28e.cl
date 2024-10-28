//{"column_indices":1,"elements":2,"row_index_buffer":6,"row_index_lookahead":5,"row_indices":0,"size":4,"vector":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void trans_unit_lu_backward(global const unsigned int* row_indices, global const unsigned int* column_indices, global const float* elements, global float* vector, unsigned int size) {
  local unsigned int row_index_lookahead[256];
  local unsigned int row_index_buffer[256];

  unsigned int row_index;
  unsigned int col_index;
  float matrix_entry;
  unsigned int nnz = row_indices[hook(0, size)];
  unsigned int row_at_window_start = size;
  unsigned int row_at_window_end;
  unsigned int loop_end = ((nnz - 1) / get_local_size(0) + 1) * get_local_size(0);

  for (unsigned int i2 = get_local_id(0); i2 < loop_end; i2 += get_local_size(0)) {
    unsigned int i = (nnz - i2) - 1;
    col_index = (i2 < nnz) ? column_indices[hook(1, i)] : 0;
    matrix_entry = (i2 < nnz) ? elements[hook(2, i)] : 0;
    row_index_lookahead[hook(5, get_local_id(0))] = (row_at_window_start >= get_local_id(0)) ? row_indices[hook(0, row_at_window_start - get_local_id(0))] : 0;

    barrier(0x01);

    if (i2 < nnz) {
      unsigned int row_index_dec = 0;
      while (row_index_lookahead[hook(5, row_index_dec)] > i)
        ++row_index_dec;
      row_index = row_at_window_start - row_index_dec;
      row_index_buffer[hook(6, get_local_id(0))] = row_index;
    } else {
      row_index = size + 1;
      row_index_buffer[hook(6, get_local_id(0))] = 0;
    }

    barrier(0x01);

    row_at_window_start = row_index_buffer[hook(6, 0)];
    row_at_window_end = row_index_buffer[hook(6, get_local_size(0) - 1)];

    for (unsigned int row2 = 0; row2 <= (row_at_window_start - row_at_window_end); ++row2) {
      unsigned int row = row_at_window_start - row2;
      float result_entry = vector[hook(3, row)];

      if ((row_index == row) && (col_index < row))
        vector[hook(3, col_index)] -= result_entry * matrix_entry;

      barrier(0x02);
    }

    row_at_window_start = row_at_window_end;
  }
}