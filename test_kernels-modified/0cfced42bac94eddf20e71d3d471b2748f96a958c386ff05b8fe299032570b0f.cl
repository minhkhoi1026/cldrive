//{"nrow":0,"row_nnz":2,"row_offset":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_csr_calc_row_nnz(const int nrow, global const int* row_offset, global int* row_nnz) {
  int ai = get_global_id(0);

  if (ai < nrow)
    row_nnz[hook(2, ai)] = row_offset[hook(1, ai + 1)] - row_offset[hook(1, ai)];
}