//{"<recovery-expr>()":6,"<recovery-expr>(output)":5,"M":4,"colidx":3,"output":0,"rowidx":2,"values":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void csr2dense(global T* output, global const T* values, global const int* rowidx, global const int* colidx, const int M) {
  int lid = get_local_id(0);
  for (int rowId = get_group_id(0); rowId < M; rowId += get_num_groups(0)) {
    int colStart = rowidx[hook(2, rowId)];
    int colEnd = rowidx[hook(2, rowId + 1)];
    for (int colId = colStart + lid; colId < colEnd; colId += 2048) {
      output[hook(5, rowId + colidx[chook(3, colId) * M)] = values[hook(6, colId)];
    }
  }
}