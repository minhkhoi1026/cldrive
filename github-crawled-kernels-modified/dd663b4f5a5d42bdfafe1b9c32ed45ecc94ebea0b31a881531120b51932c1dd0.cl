//{"col_index_buffer":6,"column_indices":1,"element_buffer":5,"elements":2,"row_indices":0,"size":4,"vector":3,"vector_buffer":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void unit_lu_backward(global const unsigned int* row_indices, global const unsigned int* column_indices, global const float* elements, global float* vector, unsigned int size) {
  local unsigned int col_index_buffer[128];
  local float element_buffer[128];
  local float vector_buffer[128];

  unsigned int nnz = row_indices[hook(0, size)];
  unsigned int current_row = size - 1;
  unsigned int row_at_window_start = size - 1;
  float current_vector_entry = vector[hook(3, size - 1)];
  unsigned int loop_end = ((nnz - 1) / get_local_size(0)) * get_local_size(0);
  unsigned int next_row = row_indices[hook(0, size - 1)];

  unsigned int i = loop_end + get_local_id(0);
  while (1) {
    if (i < nnz) {
      element_buffer[hook(5, get_local_id(0))] = elements[hook(2, i)];
      unsigned int tmp = column_indices[hook(1, i)];
      col_index_buffer[hook(6, get_local_id(0))] = tmp;
      vector_buffer[hook(7, get_local_id(0))] = vector[hook(3, tmp)];
    }

    barrier(0x01);

    if (get_local_id(0) == 0) {
      for (unsigned int k2 = 0; k2 < get_local_size(0); ++k2) {
        unsigned int k = (get_local_size(0) - k2) - 1;

        if (i + k >= nnz)
          continue;

        if (col_index_buffer[hook(6, k)] > row_at_window_start)
          current_vector_entry -= element_buffer[hook(5, k)] * vector_buffer[hook(7, k)];
        else if (col_index_buffer[hook(6, k)] > current_row)
          current_vector_entry -= element_buffer[hook(5, k)] * vector[hook(3, col_index_buffer[khook(6, k))];

        if (i + k == next_row) {
          vector[hook(3, current_row)] = current_vector_entry;
          if (current_row > 0) {
            --current_row;
            next_row = row_indices[hook(0, current_row)];
            current_vector_entry = vector[hook(3, current_row)];
          }
        }
      }

      row_at_window_start = current_row;
    }

    barrier(0x02);

    if (i < get_local_size(0))
      break;

    i -= get_local_size(0);
  }
}