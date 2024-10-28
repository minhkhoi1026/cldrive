//{"M":0,"M_internal_size2":3,"M_size1":1,"M_size2":2,"T":4,"T_internal_size2":5,"area":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy_matrix_to_tensor_area(global const float* M, unsigned int M_size1, unsigned int M_size2, unsigned int M_internal_size2, global float* T, unsigned int T_internal_size2, unsigned int area) {
  unsigned int row_gid = get_global_id(0) / get_local_size(0);
  unsigned int col_gid = get_global_id(0) % get_local_size(0);
  for (unsigned int row = row_gid; row < M_size1; row += get_num_groups(0)) {
    for (unsigned int col = col_gid; col < M_size2; col += get_local_size(0)) {
      T[hook(4, (row + area * M_size1) * T_internal_size2 + col)] = M[hook(0, row * M_internal_size2 + col)];
    }
  }
}