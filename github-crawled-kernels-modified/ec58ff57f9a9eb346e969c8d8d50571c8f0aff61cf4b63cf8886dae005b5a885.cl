//{"A":1,"T":0,"cache":4,"ncols_T":3,"nrows_T":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void transpose_lmem(global int* restrict T, global const int* restrict A, int nrows_T, int ncols_T, local int* restrict cache) {
  const int local_size = get_local_size(0);
  const int block_row_T = get_group_id(1);
  const int block_col_T = get_group_id(0);
  const int block_row_A = block_col_T;
  const int block_col_A = block_row_T;

  const int r_A = block_row_A * local_size + get_local_id(1);
  const int c_A = block_col_A * local_size + get_local_id(0);
  ;
  const int ncols_A = nrows_T;

  int effective_col = get_local_id(0) + get_local_id(1);

  if (effective_col > local_size)
    effective_col -= local_size;

  if (c_A < ncols_A && r_A < ncols_T)
    cache[hook(4, get_local_id(1) * local_size + effective_col)] = A[hook(1, r_A * ncols_A + c_A)];

  barrier(0x01);

  const int r_T = get_global_id(1);
  const int c_T = get_global_id(0);
  if (c_T < ncols_T && r_T < ncols_T)
    T[hook(0, r_T * ncols_T + c_T)] = cache[hook(4, get_local_id(0) * local_size + effective_col)];
}