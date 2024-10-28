//{"nrow":0,"perm_vec":2,"row_nnz_dst":3,"row_nnz_src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_csr_permute_row_nnz(const int nrow, global const int* row_nnz_src, global const int* perm_vec, global int* row_nnz_dst) {
  int ai = get_global_id(0);

  if (ai < nrow)
    row_nnz_dst[hook(3, perm_vec[ahook(2, ai))] = row_nnz_src[hook(1, ai)];
}