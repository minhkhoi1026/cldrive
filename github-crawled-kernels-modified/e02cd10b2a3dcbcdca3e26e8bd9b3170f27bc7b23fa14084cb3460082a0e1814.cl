//{"in_col":2,"in_row":1,"nnz":0,"out_col":5,"out_row":4,"perm":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_coo_permute(const int nnz, global const int* in_row, global const int* in_col, global const int* perm, global int* out_row, global int* out_col) {
  int ind = get_global_id(0);

  for (int i = ind; i < nnz; i += get_local_size(0)) {
    out_row[hook(4, i)] = perm[hook(3, in_row[ihook(1, i))];
    out_col[hook(5, i)] = perm[hook(3, in_col[ihook(2, i))];
  }
}