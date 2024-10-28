//{"A":0,"A_inc1":3,"A_inc2":4,"A_internal_size1":7,"A_internal_size2":8,"A_size1":5,"A_size2":6,"A_start1":1,"A_start2":2,"float2":13,"inc1":11,"inc2":15,"size1":12,"size2":16,"start1":10,"start2":14,"vec1":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void outer_prod(global float* A, unsigned int A_start1, unsigned int A_start2, unsigned int A_inc1, unsigned int A_inc2, unsigned int A_size1, unsigned int A_size2, unsigned int A_internal_size1, unsigned int A_internal_size2, global const float* vec1, unsigned int start1, unsigned int inc1, unsigned int size1, global const float* float2, unsigned int start2, unsigned int inc2, unsigned int size2) {
  unsigned int row_gid = get_global_id(0) / get_local_size(0);
  unsigned int col_gid = get_global_id(0) % get_local_size(0);
  for (unsigned int row = row_gid; row < A_size1; row += get_num_groups(0)) {
    float tmp = vec1[hook(9, row * inc1 + start1)];
    for (unsigned int col = col_gid; col < A_size2; col += get_local_size(0))
      A[hook(0, (row * A_inc1 + A_start1) * A_internal_size2 + col * A_inc2 + A_start2)] -= tmp * float2[hook(13, col * inc2 + start2)];
  }
}