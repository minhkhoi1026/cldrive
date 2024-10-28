//{"column_indices":1,"diagonal_entries":3,"elements":2,"row_index_buffer":7,"row_index_lookahead":6,"row_indices":0,"size":5,"vector":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void trans_lu_forward(global const unsigned int* row_indices, global const unsigned int* column_indices, global const float* elements, global const float* diagonal_entries, global float* vector, unsigned int size) {
  local unsigned int row_index_lookahead[256];
  local unsigned int row_index_buffer[256];

  unsigned int row_index;
  unsigned int col_index;
  float matrix_entry;
  unsigned int nnz = row_indices[hook(0, size)];
  unsigned int row_at_window_start = 0;
  unsigned int row_at_window_end = 0;
  unsigned int loop_end = ((nnz - 1) / get_local_size(0) + 1) * get_local_size(0);

  for (unsigned int i = get_local_id(0); i < loop_end; i += get_local_size(0)) {
    col_index = (i < nnz) ? column_indices[hook(1, i)] : 0;
    matrix_entry = (i < nnz) ? elements[hook(2, i)] : 0;
    row_index_lookahead[hook(6, get_local_id(0))] = (row_at_window_start + get_local_id(0) < size) ? row_indices[hook(0, row_at_window_start + get_local_id(0))] : size - 1;

    barrier(0x01);

    if (i < nnz) {
      unsigned int row_index_inc = 0;
      while (i >= row_index_lookahead[hook(6, row_index_inc + 1)])
        ++row_index_inc;
      row_index = row_at_window_start + row_index_inc;
      row_index_buffer[hook(7, get_local_id(0))] = row_index;
    } else {
      row_index = size + 1;
      row_index_buffer[hook(7, get_local_id(0))] = size - 1;
    }

    barrier(0x01);

    row_at_window_start = row_index_buffer[hook(7, 0)];
    row_at_window_end = row_index_buffer[hook(7, get_local_size(0) - 1)];

    for (unsigned int row = row_at_window_start; row <= row_at_window_end; ++row) {
      float result_entry = vector[hook(4, row)] / diagonal_entries[hook(3, row)];

      if ((row_index == row) && (col_index > row))
        vector[hook(4, col_index)] -= result_entry * matrix_entry;

      barrier(0x02);
    }

    row_at_window_start = row_at_window_end;
  }

  for (unsigned int i = get_local_id(0); i < size; i += get_local_size(0))
    vector[hook(4, i)] /= diagonal_entries[hook(3, i)];
}