//{"buffer":3,"column_indices":1,"elements":2,"row_indices":0,"size":6,"vec_entries":4,"vector":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lu_forward(global const unsigned int* row_indices, global const unsigned int* column_indices, global const float* elements, local int* buffer, local float* vec_entries, global float* vector, unsigned int size) {
  int waiting_for;
  unsigned int waiting_for_index;
  int block_offset;
  unsigned int col;
  unsigned int row;
  unsigned int row_index_end;

  for (unsigned int block_num = 0; block_num <= size / get_global_size(0); ++block_num) {
    block_offset = block_num * get_global_size(0);
    row = block_offset + get_global_id(0);
    buffer[hook(3, get_global_id(0))] = 0;
    waiting_for = -1;

    if (row < size) {
      vec_entries[hook(4, get_global_id(0))] = vector[hook(5, row)];
      waiting_for_index = row_indices[hook(0, row)];
      row_index_end = row_indices[hook(0, row + 1)];
    }

    if (get_global_id(0) == 0)
      buffer[hook(3, get_global_size(0))] = 1;

    for (unsigned int k = 0; k < get_global_size(0); ++k) {
      barrier(0x01);
      if (row < size) {
        if (waiting_for >= 0) {
          if (buffer[hook(3, waiting_for)] == 1)
            waiting_for = -1;
        }

        if (waiting_for == -1) {
          for (unsigned int j = waiting_for_index; j < row_index_end; ++j) {
            col = column_indices[hook(1, j)];
            if (col < block_offset)
              vec_entries[hook(4, get_global_id(0))] -= elements[hook(2, j)] * vector[hook(5, col)];
            else if (col < row) {
              if (buffer[hook(3, col - block_offset)] == 0) {
                waiting_for = col - block_offset;
                waiting_for_index = j;
                break;
              } else
                vec_entries[hook(4, get_global_id(0))] -= elements[hook(2, j)] * vec_entries[hook(4, col - block_offset)];
            }
          }

          if (waiting_for == -1) {
            buffer[hook(3, get_global_id(0))] = 1;
            waiting_for = -2;
          }
        }
      } else
        buffer[hook(3, get_global_id(0))] = 1;

      if (buffer[hook(3, get_global_id(0))] == 0)
        buffer[hook(3, get_global_size(0))] = 0;
      barrier(0x01);

      if (buffer[hook(3, get_global_size(0))] > 0)
        break;

      if (get_global_id(0) == 0)
        buffer[hook(3, get_global_size(0))] = 1;
    }

    if (row < size)
      vector[hook(5, row)] = vec_entries[hook(4, get_global_id(0))];

    barrier(0x02);
  }
}