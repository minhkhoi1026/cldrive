//{"A":0,"A_inc1":3,"A_inc2":4,"A_internal_size1":7,"A_internal_size2":8,"A_size1":5,"A_size2":6,"A_start1":1,"A_start2":2,"B":9,"B_inc1":12,"B_inc2":13,"B_internal_size1":14,"B_internal_size2":15,"B_start1":10,"B_start2":11,"C":16,"C_inc1":19,"C_inc2":20,"C_internal_size1":21,"C_internal_size2":22,"C_start1":17,"C_start2":18,"is_division":23}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void element_op(global float* A, unsigned int A_start1, unsigned int A_start2, unsigned int A_inc1, unsigned int A_inc2, unsigned int A_size1, unsigned int A_size2, unsigned int A_internal_size1, unsigned int A_internal_size2, global const float* B, unsigned int B_start1, unsigned int B_start2, unsigned int B_inc1, unsigned int B_inc2, unsigned int B_internal_size1, unsigned int B_internal_size2, global const float* C, unsigned int C_start1, unsigned int C_start2, unsigned int C_inc1, unsigned int C_inc2, unsigned int C_internal_size1, unsigned int C_internal_size2, unsigned int is_division) {
  unsigned int row_gid = get_global_id(0) / get_local_size(0);
  unsigned int col_gid = get_global_id(0) % get_local_size(0);

  if (is_division) {
    for (unsigned int row = row_gid; row < A_size1; row += get_num_groups(0))
      for (unsigned int col = col_gid; col < A_size2; col += get_local_size(0))
        A[hook(0, (row * A_inc1 + A_start1) * A_internal_size2 + col * A_inc2 + A_start2)] = B[hook(9, (row * B_inc1 + B_start1) * B_internal_size2 + col * B_inc2 + B_start2)] / C[hook(16, (row * C_inc1 + C_start1) * C_internal_size2 + col * C_inc2 + C_start2)];
  } else {
    for (unsigned int row = row_gid; row < A_size1; row += get_num_groups(0))
      for (unsigned int col = col_gid; col < A_size2; col += get_local_size(0))
        A[hook(0, (row * A_inc1 + A_start1) * A_internal_size2 + col * A_inc2 + A_start2)] = B[hook(9, (row * B_inc1 + B_start1) * B_internal_size2 + col * B_inc2 + B_start2)] * C[hook(16, (row * C_inc1 + C_start1) * C_internal_size2 + col * C_inc2 + C_start2)];
  }
}