//{"column_indices":1,"elements":2,"row_indices":0,"size":4,"vector":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void trans_unit_lu_forward_slow(global const unsigned int* row_indices, global const unsigned int* column_indices, global const float* elements, global float* vector, unsigned int size) {
  for (unsigned int row = 0; row < size; ++row) {
    float result_entry = vector[hook(3, row)];

    unsigned int row_start = row_indices[hook(0, row)];
    unsigned int row_stop = row_indices[hook(0, row + 1)];
    for (unsigned int entry_index = row_start + get_local_id(0); entry_index < row_stop; entry_index += get_local_size(0)) {
      unsigned int col_index = column_indices[hook(1, entry_index)];
      if (col_index > row)
        vector[hook(3, col_index)] -= result_entry * elements[hook(2, entry_index)];
    }

    barrier(0x02);
  }
}