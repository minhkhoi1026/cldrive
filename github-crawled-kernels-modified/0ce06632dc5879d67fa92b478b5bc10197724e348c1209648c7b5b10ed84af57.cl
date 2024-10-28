//{"block_offsets":4,"column_indices_U":1,"diagonal_U":3,"elements_U":2,"result":5,"row_jumper_U":0,"size":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void block_trans_lu_backward(global const unsigned int* row_jumper_U, global const unsigned int* column_indices_U, global const float* elements_U, global const float* diagonal_U, global const unsigned int* block_offsets, global float* result, unsigned int size) {
  unsigned int col_start = block_offsets[hook(4, 2 * get_group_id(0))];
  unsigned int col_stop = block_offsets[hook(4, 2 * get_group_id(0) + 1)];
  unsigned int row_start;
  unsigned int row_stop;
  float result_entry = 0;

  if (col_start >= col_stop)
    return;

  for (unsigned int iter = 0; iter < col_stop - col_start; ++iter) {
    unsigned int col = (col_stop - iter) - 1;
    result_entry = result[hook(5, col)] / diagonal_U[hook(3, col)];
    row_start = row_jumper_U[hook(0, col)];
    row_stop = row_jumper_U[hook(0, col + 1)];
    for (unsigned int buffer_index = row_start + get_local_id(0); buffer_index < row_stop; buffer_index += get_local_size(0))
      result[hook(5, column_indices_U[bhook(1, buffer_index))] -= result_entry * elements_U[hook(2, buffer_index)];
    barrier(0x02);
  }

  for (unsigned int col = col_start + get_local_id(0); col < col_stop; col += get_local_size(0))
    result[hook(5, col)] /= diagonal_U[hook(3, col)];
}