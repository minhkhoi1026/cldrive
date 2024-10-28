//{"block_offsets":3,"column_indices_L":1,"elements_L":2,"result":4,"row_jumper_L":0,"size":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void block_trans_unit_lu_forward(global const unsigned int* row_jumper_L, global const unsigned int* column_indices_L, global const float* elements_L, global const unsigned int* block_offsets, global float* result, unsigned int size) {
  unsigned int col_start = block_offsets[hook(3, 2 * get_group_id(0))];
  unsigned int col_stop = block_offsets[hook(3, 2 * get_group_id(0) + 1)];
  unsigned int row_start = row_jumper_L[hook(0, col_start)];
  unsigned int row_stop;
  float result_entry = 0;

  if (col_start >= col_stop)
    return;

  for (unsigned int col = col_start; col < col_stop; ++col) {
    result_entry = result[hook(4, col)];
    row_stop = row_jumper_L[hook(0, col + 1)];
    for (unsigned int buffer_index = row_start + get_local_id(0); buffer_index < row_stop; buffer_index += get_local_size(0))
      result[hook(4, column_indices_L[bhook(1, buffer_index))] -= result_entry * elements_L[hook(2, buffer_index)];
    row_start = row_stop;
    barrier(0x02);
  }
}