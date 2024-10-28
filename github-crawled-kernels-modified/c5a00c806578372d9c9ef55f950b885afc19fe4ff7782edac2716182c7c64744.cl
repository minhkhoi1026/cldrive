//{"column_indices":2,"elements":3,"row_index_array":0,"row_indices":1,"size":5,"vec":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void level_scheduling_substitute(global const unsigned int* row_index_array, global const unsigned int* row_indices, global const unsigned int* column_indices, global const float* elements, global float* vec, unsigned int size) {
  for (unsigned int row = get_global_id(0); row < size; row += get_global_size(0)) {
    unsigned int eq_row = row_index_array[hook(0, row)];
    float vec_entry = vec[hook(4, eq_row)];
    unsigned int row_end = row_indices[hook(1, row + 1)];

    for (unsigned int j = row_indices[hook(1, row)]; j < row_end; ++j)
      vec_entry -= vec[hook(4, column_indices[jhook(2, j))] * elements[hook(3, j)];

    vec[hook(4, eq_row)] = vec_entry;
  }
}