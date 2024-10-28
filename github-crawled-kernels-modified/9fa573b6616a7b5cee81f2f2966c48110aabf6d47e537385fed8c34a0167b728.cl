//{"A":0,"A_inc1":3,"A_inc2":4,"A_internal_size1":7,"A_internal_size2":8,"A_size1":5,"A_size2":6,"A_start1":1,"A_start2":2,"options":13,"v":9,"v_inc":11,"v_size":12,"v_start":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void triangular_substitute_inplace(global float* A, unsigned int A_start1, unsigned int A_start2, unsigned int A_inc1, unsigned int A_inc2, unsigned int A_size1, unsigned int A_size2, unsigned int A_internal_size1, unsigned int A_internal_size2, global float* v, unsigned int v_start, unsigned int v_inc, unsigned int v_size, unsigned int options) {
  float temp;
  unsigned int unit_diagonal_flag = (options & (1 << 0));
  unsigned int transposed_access_A = (options & (1 << 1));
  unsigned int is_lower_solve = (options & (1 << 2));
  unsigned int row;
  for (unsigned int rows_processed = 0; rows_processed < A_size1; ++rows_processed) {
    row = is_lower_solve ? rows_processed : ((A_size1 - rows_processed) - 1);
    if (!unit_diagonal_flag) {
      barrier(0x02);
      if (get_global_id(0) == 0)
        v[hook(9, row * v_inc + v_start)] /= A[hook(0, (row * A_inc1 + A_start1) + (row * A_inc2 + A_start2) * A_internal_size1)];
    }

    barrier(0x02);

    temp = v[hook(9, row * v_inc + v_start)];

    for (int elim = (is_lower_solve ? (row + get_global_id(0) + 1) : get_global_id(0)); elim < (is_lower_solve ? A_size1 : row); elim += get_global_size(0))
      v[hook(9, elim * v_inc + v_start)] -= temp * A[hook(0, transposed_access_A ? ((row * A_inc1 + A_start1) + (elim * A_inc2 + A_start2) * A_internal_size1) : ((elim * A_inc1 + A_start1) + (row * A_inc2 + A_start2) * A_internal_size1))];
  }
}